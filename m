Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC0FA47EC5F
	for <lists+netdev@lfdr.de>; Fri, 24 Dec 2021 08:02:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351679AbhLXHCY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Dec 2021 02:02:24 -0500
Received: from mxct.zte.com.cn ([183.62.165.209]:49446 "EHLO mxct.zte.com.cn"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351670AbhLXHCX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Dec 2021 02:02:23 -0500
X-Greylist: delayed 83950 seconds by postgrey-1.27 at vger.kernel.org; Fri, 24 Dec 2021 02:02:21 EST
Received: from mse-fl2.zte.com.cn (unknown [10.30.14.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mxct.zte.com.cn (FangMail) with ESMTPS id 4JKyfy1F2vz6Djlm;
        Fri, 24 Dec 2021 15:02:18 +0800 (CST)
Received: from kjyxapp05.zte.com.cn ([10.30.12.204])
        by mse-fl2.zte.com.cn with SMTP id 1BO72Fft053843;
        Fri, 24 Dec 2021 15:02:15 +0800 (GMT-8)
        (envelope-from wang.yi59@zte.com.cn)
Received: from mapi (kjyxapp02[null])
        by mapi (Zmail) with MAPI id mid14;
        Fri, 24 Dec 2021 15:02:15 +0800 (CST)
Date:   Fri, 24 Dec 2021 15:02:15 +0800 (CST)
X-Zmail-TransId: 2b0461c57077c091c710
X-Mailer: Zmail v1.0
Message-ID: <202112241502155477712@zte.com.cn>
In-Reply-To: <20211223105950.ovywoj6v3aooh2v5@steredhat>
References: 20211223073145.35363-1-wang.yi59@zte.com.cn,20211223105950.ovywoj6v3aooh2v5@steredhat
Mime-Version: 1.0
From:   <wang.yi59@zte.com.cn>
To:     <sgarzare@redhat.com>
Cc:     <mst@redhat.com>, <zhang.min9@zte.com.cn>,
        <wang.liang82@zte.com.cn>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>,
        <xue.zhihong@zte.com.cn>
Subject: =?UTF-8?B?UmU6W1BBVENIXSB2ZHBhOiByZWdpc3Qgdmhvc3QtdmRwYSBkZXYgY2xhc3M=?=
Content-Type: text/plain;
        charset="UTF-8"
X-MAIL: mse-fl2.zte.com.cn 1BO72Fft053843
X-Fangmail-Gw-Spam-Type: 0
X-FangMail-Miltered: at cgslv5.04-192.168.251.13.novalocal with ID 61C5707A.000 by FangMail milter!
X-FangMail-Envelope: 1640329338/4JKyfy1F2vz6Djlm/61C5707A.000/10.30.14.239/[10.30.14.239]/mse-fl2.zte.com.cn/<wang.yi59@zte.com.cn>
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 61C5707A.000/4JKyfy1F2vz6Djlm
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Stefano,

Thanks for your quick reply and review, :)

> On Thu, Dec 23, 2021 at 03:31:45PM +0800, Yi Wang wrote:
> >From: Zhang Min <zhang.min9@zte.com.cn>
> >
> >Some applications like kata-containers need to acquire MAJOR/MINOR/DEVNAME
> >for devInfo [1], so regist vhost-vdpa dev class to expose uevent.
> >
> >1. https://github.com/kata-containers/kata-containers/blob/main/src/runtime/virtcontainers/device/config/config.go
> >
> >Signed-off-by: Zhang Min <zhang.min9@zte.com.cn>
> >Signed-off-by: Yi Wang <wang.yi59@zte.com.cn>
> >---
> > drivers/vhost/vdpa.c | 12 ++++++++++++
> > 1 file changed, 12 insertions(+)
> >
> >diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> >index fb41db3da611..90fbad93e7a2 100644
> >--- a/drivers/vhost/vdpa.c
> >+++ b/drivers/vhost/vdpa.c

..

> >+    vhost_vdpa_class = class_create(THIS_MODULE, "vhost-vdpa");
> >+    if (IS_ERR(vhost_vdpa_class)) {
> >+        r = PTR_ERR(vhost_vdpa_class);
> >+        pr_warn("vhost vdpa class create error %d,  maybe mod reinserted\n", r);
>                                                            ^
> double space.
> 
> I'm not a native speaker, but I would rephrase the second part to "maybe 
> the module is already loaded"
> 
> >+        vhost_vdpa_class = NULL;
> >+        return r;
> >+    }
> >+
> >     r = alloc_chrdev_region(&vhost_vdpa_major, 0, VHOST_VDPA_DEV_MAX,
> >                 "vhost-vdpa");
> >     if (r)
> >@@ -1111,6 +1121,7 @@ static int __init vhost_vdpa_init(void)
> > err_vdpa_register_driver:
> >     unregister_chrdev_region(vhost_vdpa_major, VHOST_VDPA_DEV_MAX);
> > err_alloc_chrdev:
> >+    class_destroy(vhost_vdpa_class);
> 
> Should we set `vhost_vdpa_class` to NULL here?
> 
> If yes, maybe better to add a new label, and a goto in the 
> `class_create` error handling.

Yes, reset to NULL is unnecessary, and pr_warn will not be reached when module
is already loaded, so it's no need too.
There will be a v2 patch which simply return PTR_ERR(vhost_vdpa_class);
Other suggestions are also accepted. 

> >     return r;
> > }
