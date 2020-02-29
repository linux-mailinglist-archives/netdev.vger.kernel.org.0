Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 546111749B5
	for <lists+netdev@lfdr.de>; Sat, 29 Feb 2020 23:30:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727306AbgB2W31 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Feb 2020 17:29:27 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:33750 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726786AbgB2W30 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Feb 2020 17:29:26 -0500
Received: by mail-wr1-f68.google.com with SMTP id x7so7826141wrr.0;
        Sat, 29 Feb 2020 14:29:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=JUcStTd1OYnX+4/KTZoNwT3pKFBsMhYYxXgdxB6jewU=;
        b=W7j93h5+gAXFNx9VjTexyPvITCCvM44iEc9yXZLJWWLzai9hpbYKLIPlAjzD61SKGy
         NfQCBuAYb0M6t5HyCnmkWvzu7e2kJCxUa4lL6GfIm/8nsgALkayLXcSQ11KNVgoLfUjp
         dR0iUK1MWrbED6doNC+8a6LcjaYZFtw3nXLG+cFCzYIxbc+hP4gbGiFJwSNSsRcn6YMr
         qFs/0sr/K6WqfQWm5OIzt53tNNbyEvKJwTYttGysoXUJsPjCgOr/MGIqHHnYDIWbv59W
         hyWN/KajLBnQF369IgqPkFZh42HTTMAMuKgC8rd8PEA5J3DYEqz0H3mowyc8mOvAPslA
         cHjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JUcStTd1OYnX+4/KTZoNwT3pKFBsMhYYxXgdxB6jewU=;
        b=F5XBMskfak5fPZRHhESnq1g5wOxKemBsYzT7oUbXgB4MGhNNDbteQRf0FrpQ0cNtNN
         RCQODVVUpV7sfd8vs6auLnnyPW70sFAF8g285yFbF2zdeS5X1LCuxVIo5hQpLuoD7vcj
         CWKH9ligM8l2vOzNRNBWJ1yqKemwRfTS3GOO7zGWzfz08ebxv2RnoARmQRdmP4UI/yZx
         d+wTObP4+2wCHIN1/PnpT8ysn7E/Jlq/HXcFuDjAf9ViBZPkhZQminXldZTZCza5RR18
         fDuvnl0zsKekcwrQAoyfJ3uWONWgcwVxPdrGyiN0OK2knOKRss56j29E45ufgdQ0SmjR
         L9Sg==
X-Gm-Message-State: APjAAAUiWy9+MWg4Ay+GP7yjhIAH/yLsrpNmPVA7R4+qiLA1x3J3UkKc
        nFpyyK6D+X/byctufsxMtI4a0RX5
X-Google-Smtp-Source: APXvYqxDK8DmyGmZovFQT4NhCchWjRPiRjKFyOka2xlPwNfL3r2zy7c1fFhpYk0IV1YBKCtG+HsPdQ==
X-Received: by 2002:a5d:424c:: with SMTP id s12mr12210642wrr.244.1583015364175;
        Sat, 29 Feb 2020 14:29:24 -0800 (PST)
Received: from ?IPv6:2003:ea:8f29:6000:7150:76fe:91ca:7ab5? (p200300EA8F296000715076FE91CA7AB5.dip0.t-ipconnect.de. [2003:ea:8f29:6000:7150:76fe:91ca:7ab5])
        by smtp.googlemail.com with ESMTPSA id q3sm7781235wmj.38.2020.02.29.14.29.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 29 Feb 2020 14:29:23 -0800 (PST)
Subject: [PATCH v4 01/10] net: marvell: add PCI_STATUS_SIG_TARGET_ABORT to PCI
 status error bits
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Bjorn Helgaas <bhelgaas@google.com>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>,
        Mirko Lindner <mlindner@marvell.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Clemens Ladisch <clemens@ladisch.de>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>
Cc:     "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        alsa-devel@alsa-project.org
References: <adeb9e6e-9be6-317f-3fc0-a4e6e6af5f81@gmail.com>
Message-ID: <497952d4-de09-e268-0e2a-511a473198d7@gmail.com>
Date:   Sat, 29 Feb 2020 23:20:32 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <adeb9e6e-9be6-317f-3fc0-a4e6e6af5f81@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation of factoring out PCI_STATUS error bit handling let drivers
use the same collection of error bits. To facilitate bisecting we do this
in a separate patch per affected driver. For the Marvell drivers we have
to add PCI_STATUS_SIG_TARGET_ABORT to the error bits.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/marvell/skge.h | 1 +
 drivers/net/ethernet/marvell/sky2.h | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/marvell/skge.h b/drivers/net/ethernet/marvell/skge.h
index 6fa7b6a34..e76c03c87 100644
--- a/drivers/net/ethernet/marvell/skge.h
+++ b/drivers/net/ethernet/marvell/skge.h
@@ -19,6 +19,7 @@
 			       PCI_STATUS_SIG_SYSTEM_ERROR | \
 			       PCI_STATUS_REC_MASTER_ABORT | \
 			       PCI_STATUS_REC_TARGET_ABORT | \
+			       PCI_STATUS_SIG_TARGET_ABORT | \
 			       PCI_STATUS_PARITY)
 
 enum csr_regs {
diff --git a/drivers/net/ethernet/marvell/sky2.h b/drivers/net/ethernet/marvell/sky2.h
index b02b65230..aee87f838 100644
--- a/drivers/net/ethernet/marvell/sky2.h
+++ b/drivers/net/ethernet/marvell/sky2.h
@@ -256,6 +256,7 @@ enum {
 			       PCI_STATUS_SIG_SYSTEM_ERROR | \
 			       PCI_STATUS_REC_MASTER_ABORT | \
 			       PCI_STATUS_REC_TARGET_ABORT | \
+			       PCI_STATUS_SIG_TARGET_ABORT | \
 			       PCI_STATUS_PARITY)
 
 enum csr_regs {
-- 
2.25.1


