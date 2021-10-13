Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D0CD42C2E3
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 16:22:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236701AbhJMOYu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 10:24:50 -0400
Received: from alexa-out.qualcomm.com ([129.46.98.28]:14526 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235899AbhJMOYl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Oct 2021 10:24:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1634134958; x=1665670958;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=QLxl0HoobPToMMkExPECA79JKwgJz+rF51IZKeXVMAA=;
  b=UtRLKzkk643Ek+LsTu/gYJDoE0EdmT7jNm6wjqVDqIJl+bPB5unf7Yow
   3X5EnpqwKQW950ZNm46DPx95VJrSlgGKCK/FbeezWzdAa+fnV124WaZOo
   Yyt9PCow09VyN/I5LHWBlrPfgpTFq3VltkQq1jrGYR0uG4lNAaaqP+EZH
   M=;
Received: from ironmsg-lv-alpha.qualcomm.com ([10.47.202.13])
  by alexa-out.qualcomm.com with ESMTP; 13 Oct 2021 07:22:38 -0700
X-QCInternal: smtphost
Received: from nalasex01a.na.qualcomm.com ([10.47.209.196])
  by ironmsg-lv-alpha.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2021 07:22:37 -0700
Received: from [10.111.161.132] (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.922.7; Wed, 13 Oct 2021
 07:22:36 -0700
Message-ID: <64b87f6b-5db9-721f-1bb8-6ae29742bf96@quicinc.com>
Date:   Wed, 13 Oct 2021 10:22:35 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH 1/5] PCI/VPD: Add pci_read/write_vpd_any()
Content-Language: en-US
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Raju Rangoju <rajur@chelsio.com>
CC:     "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <ba0b18a3-64d8-d72f-9e9f-ad3e4d7ae3b8@gmail.com>
 <93ecce28-a158-f02a-d134-8afcaced8efe@gmail.com>
 <e89087c5-c495-c5ca-feb1-54cf3a8775c5@quicinc.com>
 <ca805454-6ec5-303b-d39f-d505cad6b338@gmail.com>
From:   Qian Cai <quic_qiancai@quicinc.com>
In-Reply-To: <ca805454-6ec5-303b-d39f-d505cad6b338@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/12/2021 4:26 PM, Heiner Kallweit wrote:
> Thanks for the report! I could reproduce the issue, the following fixes
> it for me. Could you please test whether it fixes the issue for you as well?

Yes, it works fine. BTW, in the original patch here:

--- a/drivers/pci/vpd.c
+++ b/drivers/pci/vpd.c
@@ -138,9 +138,10 @@ static int pci_vpd_wait(struct pci_dev *dev, bool set)
 }
 
 static ssize_t pci_vpd_read(struct pci_dev *dev, loff_t pos, size_t count,
-			    void *arg)
+			    void *arg, bool check_size)
 {
 	struct pci_vpd *vpd = &dev->vpd;
+	unsigned int max_len = check_size ? vpd->len : PCI_VPD_MAX_SIZE;
 	int ret = 0;
 	loff_t end = pos + count;
 	u8 *buf = arg;
@@ -151,11 +152,11 @@ static ssize_t pci_vpd_read(struct pci_dev *dev, loff_t pos, size_t count,
 	if (pos < 0)
 		return -EINVAL;
 
-	if (pos > vpd->len)
+	if (pos >= max_len)
 		return 0;

I am not sure if "pos >= max_len" is correct there, so just want to give you
a chance to double-check.
