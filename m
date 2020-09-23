Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 075862753FA
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 11:06:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726599AbgIWJGg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 05:06:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726178AbgIWJGg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 05:06:36 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F514C0613CE;
        Wed, 23 Sep 2020 02:06:36 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id u4so781346plr.4;
        Wed, 23 Sep 2020 02:06:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=4hMw1RpDG2ueDcMztQfcOaK5AOnLojLAqwfMF9XGROw=;
        b=MN7prrBhdAPs9exEUsWKusuKzl+zDaoVHcta4SOezeQVnnRK5JTMfxKgvIRUrfqlX1
         JxxNYW8aKO7LGB3q24iqWgnrCuatOU5YRcc6Q2jSee48qbDjTJiJ0o5sngLHOyXQJC1H
         Cbqo9NTVpBOOmOmJHvCR4b1bxBYGTHFHET3VyrHj29oOVO+6sHKRCAdlZfzbFHByduhq
         VFBgRY7th3zbBn/cbsRKwvjQDkcpHC3814F2BQ6Zi9ET8dx8ImzcO7qykgSJqJQ2E6X4
         XyvCPI1SxjoPQggMxxlUh+a462MlD8gFNWEpwb7U1TXPENOcWl40BPj7GEIZYSJ+6cc6
         Rseg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=4hMw1RpDG2ueDcMztQfcOaK5AOnLojLAqwfMF9XGROw=;
        b=aXvUXeUJB8a4EVaWj+R+jd1ed6hVoZ0ZRI9buxvxjG+cLD6ionZ689wQfhmIwzCPsh
         XyYV/OpB8Bi8G0AqBpOzVpsIA2LlDBp5fegdA0Rnhe6mMNrfHAIUOIkG/ckgP4kYdHgX
         3YOGrfSQ0jtzpQHOXSfUgjR6GnhYn4Tg5GxDNTjuYCnctVogq4/v1OsjO4xSxdSoRVTI
         RP/yrQMqdTc4mxNSQuYaN04MDBbG8d5ibqbtkpN6nh7gPTz8sQ/Z20zp0NcpcrTY8zog
         lC0ZGtKhg+iDRlSlbtw46HE5ubOwny77p22W1Z0BZUfSsPq+2b4QxLM1T/xWwO22lbmF
         o+8w==
X-Gm-Message-State: AOAM5337UGrVtu765ViVK0B0BYYSzR3EYmVK1FF5Qn317OHNhE4JU+ta
        h9QuS3vqQYXUL3HzpF/NaYQ=
X-Google-Smtp-Source: ABdhPJzxcZopb1qURZ4Ezng98Hm8eG9OwKY8RKzypvJ2LdSnc67p6QCdccsb2i+2hqermlODln9MnQ==
X-Received: by 2002:a17:902:ab87:b029:d2:1ceb:34 with SMTP id f7-20020a170902ab87b02900d21ceb0034mr8728665plr.12.1600851995638;
        Wed, 23 Sep 2020 02:06:35 -0700 (PDT)
Received: from localhost.localdomain ([2405:205:c8e3:4b96:985a:95b9:e0cd:1d5e])
        by smtp.gmail.com with ESMTPSA id a13sm16496226pgq.41.2020.09.23.02.06.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2020 02:06:35 -0700 (PDT)
From:   Himadri Pandya <himadrispandya@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, oneukum@suse.com,
        pankaj.laxminarayan.bharadiya@intel.com, keescook@chromium.org,
        yuehaibing@huawei.com, petkan@nucleusys.com, ogiannou@gmail.com
Cc:     linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        gregkh@linuxfoundation.org,
        Himadri Pandya <himadrispandya@gmail.com>
Subject: [PATCH 2/4] net: sierra_net: use usb_control_msg_recv()
Date:   Wed, 23 Sep 2020 14:35:17 +0530
Message-Id: <20200923090519.361-3-himadrispandya@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200923090519.361-1-himadrispandya@gmail.com>
References: <20200923090519.361-1-himadrispandya@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The new usb api function usb_control_msg_recv() nicely wrapps
usb_control_msg() with proper error check. Hence use it instead of
directly calling usb_control_msg().

Signed-off-by: Himadri Pandya <himadrispandya@gmail.com>
---
 drivers/net/usb/sierra_net.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/drivers/net/usb/sierra_net.c b/drivers/net/usb/sierra_net.c
index 0abd257b634c..f3a5f83cb256 100644
--- a/drivers/net/usb/sierra_net.c
+++ b/drivers/net/usb/sierra_net.c
@@ -478,16 +478,13 @@ static void sierra_net_kevent(struct work_struct *work)
 			return;
 
 		ifnum = priv->ifnum;
-		len = usb_control_msg(dev->udev, usb_rcvctrlpipe(dev->udev, 0),
-				USB_CDC_GET_ENCAPSULATED_RESPONSE,
-				USB_DIR_IN|USB_TYPE_CLASS|USB_RECIP_INTERFACE,
-				0, ifnum, buf, SIERRA_NET_USBCTL_BUF_LEN,
-				USB_CTRL_SET_TIMEOUT);
-
-		if (len < 0) {
-			netdev_err(dev->net,
-				"usb_control_msg failed, status %d\n", len);
-		} else {
+		len = usb_control_msg_recv(dev->udev, usb_rcvctrlpipe(dev->udev, 0),
+					   USB_CDC_GET_ENCAPSULATED_RESPONSE,
+					   USB_DIR_IN | USB_TYPE_CLASS | USB_RECIP_INTERFACE,
+					   0, ifnum, buf, SIERRA_NET_USBCTL_BUF_LEN,
+					   USB_CTRL_SET_TIMEOUT);
+
+		if (len) {
 			struct hip_hdr	hh;
 
 			dev_dbg(&dev->udev->dev, "%s: Received status message,"
-- 
2.17.1

