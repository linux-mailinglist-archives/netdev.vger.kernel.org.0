Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C1A19BC95
	for <lists+netdev@lfdr.de>; Sat, 24 Aug 2019 10:36:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726485AbfHXIgg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Aug 2019 04:36:36 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:45583 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725974AbfHXIgf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Aug 2019 04:36:35 -0400
Received: by mail-pg1-f195.google.com with SMTP id o13so7218887pgp.12
        for <netdev@vger.kernel.org>; Sat, 24 Aug 2019 01:36:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=C+jf+R4y9HYvgOjBKi1gq/93noPWWTH9DsHbrZsbFqU=;
        b=kYUxjkTVPqE3PBir8dUmdh2APO/FveN7P6DEHykMFX8HlAGTkAMLS3Ju7WVuSDFlp1
         N6qhY+CGq+0DNEaVA9t2881m+FWAYaeAmHpjabwVkrZGd7Ao/q4BxeQUXHpCyuR8Q8Be
         mbQUOvH0+UpDotgApY6EnYQKhL5RloBdxyKIY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=C+jf+R4y9HYvgOjBKi1gq/93noPWWTH9DsHbrZsbFqU=;
        b=sqk1e1i5o0V+ZGuXqd6AE54TwcvABn/QsZWDpc/gV2Gl4eFOacLzmA6A3JIfw8Zw1x
         6FOXyiD3HjBXn6iYgk6a3Lfv3/1BqyochRL48wVKls5XbPEpItRAx2xYtzLDjT/+nW3N
         YnbqG/mibw2wGMmK5QZLD+EyfyhByd/GGuHTQHraGxtHQth1K+yBcLJFmudbLDSMIclc
         aMOkTmEA2oxIo5fpb83DFgV+wzI5ZbNb1F9iG71mg4OPgtPuMMYwQm2BLvJ0YFNYfvOz
         486/jm76cp9Gtb11PfTh5CpHJp+yzMakb3kNYXr+gKmUIRRAbozJVS5kFArBiIPl+Ucu
         FRTQ==
X-Gm-Message-State: APjAAAUWP7oJM96MaK1tOVONt9WcEr6H5JKeIzjsG7yQumhMOKKn7BfW
        PKZVyHoch0Gpq/OLaCRN+WMpCw==
X-Google-Smtp-Source: APXvYqw9aoHZM4lN10HAiKVkJOUCKYww50zrd+jFxE+ijgPfef/h6Vzhwv+N086hgiusxEefqoZnNA==
X-Received: by 2002:a63:e610:: with SMTP id g16mr7241064pgh.392.1566635795038;
        Sat, 24 Aug 2019 01:36:35 -0700 (PDT)
Received: from pmalani2.mtv.corp.google.com ([2620:15c:202:201:172e:4646:c089:ce59])
        by smtp.gmail.com with ESMTPSA id 65sm6140309pff.148.2019.08.24.01.36.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Aug 2019 01:36:34 -0700 (PDT)
From:   Prashant Malani <pmalani@chromium.org>
To:     hayeswang@realtek.com, davem@davemloft.net
Cc:     grundler@chromium.org, netdev@vger.kernel.org,
        Prashant Malani <pmalani@chromium.org>
Subject: [PATCH] r8152: Set memory to all 0xFFs on failed reg reads
Date:   Sat, 24 Aug 2019 01:36:19 -0700
Message-Id: <20190824083619.69139-1-pmalani@chromium.org>
X-Mailer: git-send-email 2.23.0.187.g17f5b7556c-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

get_registers() blindly copies the memory written to by the
usb_control_msg() call even if the underlying urb failed.

This could lead to junk register values being read by the driver, since
some indirect callers of get_registers() ignore the return values. One
example is:
  ocp_read_dword() ignores the return value of generic_ocp_read(), which
  calls get_registers().

So, emulate PCI "Master Abort" behavior by setting the buffer to all
0xFFs when usb_control_msg() fails.

This patch is copied from the r8152 driver (v2.12.0) published by
Realtek (www.realtek.com).

Signed-off-by: Prashant Malani <pmalani@chromium.org>
---
 drivers/net/usb/r8152.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 0cc03a9ff545..eee0f5007ee3 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -799,8 +799,11 @@ int get_registers(struct r8152 *tp, u16 value, u16 index, u16 size, void *data)
 	ret = usb_control_msg(tp->udev, usb_rcvctrlpipe(tp->udev, 0),
 			      RTL8152_REQ_GET_REGS, RTL8152_REQT_READ,
 			      value, index, tmp, size, 500);
+	if (ret < 0)
+		memset(data, 0xff, size);
+	else
+		memcpy(data, tmp, size);
 
-	memcpy(data, tmp, size);
 	kfree(tmp);
 
 	return ret;
-- 
2.23.0.187.g17f5b7556c-goog

