Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A24CD3B22C3
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 23:50:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229873AbhFWVwd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 17:52:33 -0400
Received: from mail-pg1-f181.google.com ([209.85.215.181]:33687 "EHLO
        mail-pg1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229800AbhFWVwc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Jun 2021 17:52:32 -0400
Received: by mail-pg1-f181.google.com with SMTP id e20so2959196pgg.0;
        Wed, 23 Jun 2021 14:50:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NcuezbW/3QXd9xoo1Wqe4V3CcqkkgQiQqDXARjEpQrQ=;
        b=c56Ed57gWQz/r9nk52t+b9yW5Qj2IuaKDUGffsz075Iscs96rCWUOVZTBQQHPa/jK1
         9CpIpPU+OSGfiauTMOFiXUM6LIMNnB0xnPBRVC3s96nKSSldo+rhoHf42W4rFTKv/bWX
         gLY6tGLWHTskUn9uC9WtAfpf3Y798QgtaTqbSUoX7Mqv42yXvjvQw//PuW5BmNXzw1Sq
         H5h1Ejt0c1amEvtf+nKRz3M8bdVt89TzS2utq+zlt4tiZgdgT/xlr0BgnfrWvoUFsgpt
         +3GZh+B1JEvWm44KcC0KEADMwEeVYh+I/yLqE3RcUMVb/ZNcPLHCCdVcEA960BkljNsg
         j5sA==
X-Gm-Message-State: AOAM531xB+pXBMskZG8Y1TmAlf5I46I+09mHTygMl+Lt2gVyw7cDo9C+
        YIUDRTm10cgqEbJH7Yg+bcI=
X-Google-Smtp-Source: ABdhPJzDgKF3Tc86z1h/sQHaNFZ1VoEUhCcL00uHO/syYNpcu4lIF731nF/TnUYj7N75aSD6W3AmAA==
X-Received: by 2002:a05:6a00:21c7:b029:2ec:2bfa:d0d1 with SMTP id t7-20020a056a0021c7b02902ec2bfad0d1mr1751644pfj.14.1624485014356;
        Wed, 23 Jun 2021 14:50:14 -0700 (PDT)
Received: from localhost ([191.96.121.71])
        by smtp.gmail.com with ESMTPSA id 30sm461291pjz.42.2021.06.23.14.50.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Jun 2021 14:50:12 -0700 (PDT)
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     gregkh@linuxfoundation.org, rafael@kernel.org, davem@davemloft.net,
        kuba@kernel.org, ast@kernel.org, andriin@fb.com,
        daniel@iogearbox.net, atenart@kernel.org, alobakin@pm.me,
        weiwan@google.com, ap420073@gmail.com
Cc:     jeyu@kernel.org, ngupta@vflare.org,
        sergey.senozhatsky.work@gmail.com, minchan@kernel.org,
        mcgrof@kernel.org, axboe@kernel.dk, mbenes@suse.com,
        jpoimboe@redhat.com, tglx@linutronix.de, keescook@chromium.org,
        jikos@kernel.org, rostedt@goodmis.org, peterz@infradead.org,
        linux-block@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4] sysfs: fix kobject refcount to address races with kobject removal
Date:   Wed, 23 Jun 2021 14:50:07 -0700
Message-Id: <20210623215007.862787-1-mcgrof@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It's possible today to have a device attribute read or store
race against device removal. This is known to happen as follows:

write system call -->
  ksys_write () -->
    vfs_write() -->
      __vfs_write() -->
        kernfs_fop_write_iter() -->
          sysfs_kf_write() -->
            dev_attr_store() -->
              null reference

This happens because the dev_attr->store() callback can be
removed prior to its call, after dev_attr_store() was initiated.
The null dereference is possible because the sysfs ops can be
removed on module removal, for instance, when device_del() is
called, and a sysfs read / store is not doing any kobject reference
bumps either. This allows a read/store call to initiate, a
device_del() to kick off, and then the read/store call can be
gone by the time to execute it.

The sysfs filesystem is not doing any kobject reference bumps during a
read / store ops to prevent this.

To fix this in a simplified way, just bump the kobject reference when
we create a directory and remove it on directory removal.

The big unfortunate eye-sore is addressing the manual kobject reference
assumption on the networking code, which leads me to believe we should
end up replacing that eventually with another sort of check.

Suggested-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---

This v4 moves to fixing the race condition on dev_attr_store() and
dev_attr_read() to sysfs by bumping the kobject reference count
on directory creation / deletion as suggested by Greg.

Unfortunately at least the networking core has a manual refcount
assumption, which needs to be adjusted to account for this change.
This should also mean there is runtime for other kobjects which may
not be explored yet which may need fixing as well. We may want to
change the check to something else on the networking front, but its
not clear to me yet what to use.

 fs/sysfs/dir.c | 3 +++
 net/core/dev.c | 4 ++--
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 59dffd5ca517..6c47aa4af6f5 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -56,12 +56,14 @@ int sysfs_create_dir_ns(struct kobject *kobj, const void *ns)
 
 	kobject_get_ownership(kobj, &uid, &gid);
 
+	kobject_get(kobj);
 	kn = kernfs_create_dir_ns(parent, kobject_name(kobj),
 				  S_IRWXU | S_IRUGO | S_IXUGO, uid, gid,
 				  kobj, ns);
 	if (IS_ERR(kn)) {
 		if (PTR_ERR(kn) == -EEXIST)
 			sysfs_warn_dup(parent, kobject_name(kobj));
+		kobject_put(kobj);
 		return PTR_ERR(kn);
 	}
 
@@ -100,6 +102,7 @@ void sysfs_remove_dir(struct kobject *kobj)
 	if (kn) {
 		WARN_ON_ONCE(kernfs_type(kn) != KERNFS_DIR);
 		kernfs_remove(kn);
+		kobject_put(kobj);
 	}
 }
 
diff --git a/net/core/dev.c b/net/core/dev.c
index 222b1d322c96..3a0ffa603d14 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -10429,7 +10429,7 @@ static void netdev_wait_allrefs(struct net_device *dev)
 	rebroadcast_time = warning_time = jiffies;
 	refcnt = netdev_refcnt_read(dev);
 
-	while (refcnt != 1) {
+	while (refcnt != 3) {
 		if (time_after(jiffies, rebroadcast_time + 1 * HZ)) {
 			rtnl_lock();
 
@@ -10544,7 +10544,7 @@ void netdev_run_todo(void)
 		netdev_wait_allrefs(dev);
 
 		/* paranoia */
-		BUG_ON(netdev_refcnt_read(dev) != 1);
+		BUG_ON(netdev_refcnt_read(dev) != 3);
 		BUG_ON(!list_empty(&dev->ptype_all));
 		BUG_ON(!list_empty(&dev->ptype_specific));
 		WARN_ON(rcu_access_pointer(dev->ip_ptr));
-- 
2.27.0

