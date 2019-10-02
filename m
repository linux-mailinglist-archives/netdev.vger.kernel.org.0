Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95296C8DF5
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 18:13:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728062AbfJBQMp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 12:12:45 -0400
Received: from mail-wr1-f48.google.com ([209.85.221.48]:36937 "EHLO
        mail-wr1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727737AbfJBQMl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 12:12:41 -0400
Received: by mail-wr1-f48.google.com with SMTP id i1so20363453wro.4
        for <netdev@vger.kernel.org>; Wed, 02 Oct 2019 09:12:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GKER0aCVB7aAXBACEj1WlpKIkKyg0SV7tqW0hXQJYuA=;
        b=EQKIhHB8bMc33BWYpGxheHVVBfX3SidQAqFo7a5DGMCaC1g7SckfoXMx51VM+irbmM
         69z1ET3iQ+GuRtXGb80rVsp54ZZ4WEj7sL6cpoY2x7MvpGeZ2mPnBgNjZVpWVoLRsP1T
         UoubPXts5zkVCpMmoapvhWnLsvZUZyXTN1H6IImTUwokdpREjo1xJ334S46B4/EL2bNb
         oJf0pJbqiFZWu15l0DqQcUTUEGANsUkXGN5dItkivUJdFDlsOHSg4mxPqcZ3mKMkLnik
         nKOdYX/zJK5h2KAg7OvjL1aPf9u4pP9oS5uksaSrJ1zYu5RWhXt+1a8UKyFPUeRhUlFn
         aUYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GKER0aCVB7aAXBACEj1WlpKIkKyg0SV7tqW0hXQJYuA=;
        b=EAwpzSFEPhOF5IYDJdkkjTbmjgHQJ27L0cTFbC92N7T4LV28pl3ypjDfDuVCOwqrbT
         EyVXZe0if4OzafTKYFYPRl2YI07sP1bIa9t23Rits5ciMss7HwAp+vxyaT5lcV50Vvd+
         fQPmBevEIEuHs9t9Ugkiy2pLv53TBV/yIYKxZrlbEktTtklrG7pYoDYurSknux/Y7u6U
         Zk53zzhhHAmACX0nEi29Y5mFUxEQYixnavA9dkXqWO+n+dtM6gld82fagvwYs2VEKn+R
         lATHRldFKxW/Yh4KiTcc1hIRr7BriL+HPW0loxPU9YtxiKuT65cA/mv9bIWgijZYbY3m
         c/Sg==
X-Gm-Message-State: APjAAAU8t1GVbuppWmTTy8Pms2rv88g90+NbzNIPtIrXDgLofg5K/WJQ
        7chQTioGB4E8u5m2iBn5FjVgR3dsirY=
X-Google-Smtp-Source: APXvYqyxg1GABlRfvDPa+//SOpIMrdHiHAI23NU3X/JUo3S0BkZMN/rw9QlnpZA+79lM2iu5VN+sAg==
X-Received: by 2002:adf:f68f:: with SMTP id v15mr766034wrp.210.1570032758986;
        Wed, 02 Oct 2019 09:12:38 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id o70sm7499322wme.29.2019.10.02.09.12.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Oct 2019 09:12:38 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, idosch@mellanox.com, dsahern@gmail.com,
        jakub.kicinski@netronome.com, tariqt@mellanox.com,
        saeedm@mellanox.com, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        shuah@kernel.org, mlxsw@mellanox.com
Subject: [patch net-next v2 06/15] net: devlink: export devlink net getter
Date:   Wed,  2 Oct 2019 18:12:22 +0200
Message-Id: <20191002161231.2987-7-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191002161231.2987-1-jiri@resnulli.us>
References: <20191002161231.2987-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Allow drivers to get net struct for devlink instance.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
 include/net/devlink.h | 1 +
 net/core/devlink.c    | 3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index 23e4b65ec9df..5ac2be0f0857 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -771,6 +771,7 @@ static inline struct devlink *netdev_to_devlink(struct net_device *dev)
 
 struct ib_device;
 
+struct net *devlink_net(const struct devlink *devlink);
 struct devlink *devlink_alloc(const struct devlink_ops *ops, size_t priv_size);
 int devlink_register(struct devlink *devlink, struct device *dev);
 void devlink_unregister(struct devlink *devlink);
diff --git a/net/core/devlink.c b/net/core/devlink.c
index e48680efe54a..362cbbcca225 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -95,10 +95,11 @@ static LIST_HEAD(devlink_list);
  */
 static DEFINE_MUTEX(devlink_mutex);
 
-static struct net *devlink_net(const struct devlink *devlink)
+struct net *devlink_net(const struct devlink *devlink)
 {
 	return read_pnet(&devlink->_net);
 }
+EXPORT_SYMBOL_GPL(devlink_net);
 
 static void devlink_net_set(struct devlink *devlink, struct net *net)
 {
-- 
2.21.0

