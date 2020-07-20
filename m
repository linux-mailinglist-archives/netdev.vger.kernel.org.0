Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78D15226355
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 17:30:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728593AbgGTPaP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 11:30:15 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:31446 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726899AbgGTPaO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 11:30:14 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06KFU3jJ028595;
        Mon, 20 Jul 2020 08:30:07 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0818;
 bh=0xdZMKt+U7nc+qc2EGzH2Mt6XJPg3diT9cpjObCq0HM=;
 b=fTHeSVsV9iwWiZp0fu3DMWqzeZjVWtoh0abil1mm6B0C6HvhFnpLzSV4IMjEZcadQAHI
 AEcWL7+3OLOVLexYbT8uD9VMPMOze6ANAB4jucQWS++hgM3trIwKiWMcTnThU3SZXc5X
 Pfic51wcgSVsCc7D00aQPJPVRmObeXD6EY8GjHun1VLmbD6jF8GJEf0pPcxBO9z2kn/x
 mDW16wLnuYhN9UquJtfMj/eMt4kTXFwY8u3HCf9xdH3oa3HUBO1hSwvN/YJBIzxpIjAI
 u0kSZnw+ifw7H0W951Ok/aOfkDXYrD38QAw1QYXP2y9d7Ud0M9MZMKJEdavqWiweHxAP nA== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 32bxenf600-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 20 Jul 2020 08:30:06 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 20 Jul
 2020 08:30:05 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 20 Jul
 2020 08:30:04 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 20 Jul 2020 08:30:04 -0700
Received: from NN-LT0049.marvell.com (NN-LT0049.marvell.com [10.193.54.6])
        by maili.marvell.com (Postfix) with ESMTP id 46C623F703F;
        Mon, 20 Jul 2020 08:29:59 -0700 (PDT)
From:   Alexander Lobakin <alobakin@marvell.com>
To:     Joe Perches <joe@perches.com>
CC:     Alexander Lobakin <alobakin@marvell.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Igor Russkikh <irusskikh@marvell.com>,
        Michal Kalderon <michal.kalderon@marvell.com>,
        Ariel Elior <aelior@marvell.com>,
        "Denis Bolotin" <denis.bolotin@marvell.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        <GR-everest-linux-l2@marvell.com>,
        <QLogic-Storage-Upstream@marvell.com>, <netdev@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 net-next 01/14] qed: convert link mode from u32 to bitmap
Date:   Mon, 20 Jul 2020 18:29:30 +0300
Message-ID: <20200720152930.8485-1-alobakin@marvell.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <de4b0ef6b1b7b58acc184d1d7e80456f6c3b56c0.camel@perches.com>
References: <de4b0ef6b1b7b58acc184d1d7e80456f6c3b56c0.camel@perches.com>
 <20200719212100.GM1383417@lunn.ch>
 <20200719201453.3648-1-alobakin@marvell.com>
 <20200719201453.3648-2-alobakin@marvell.com>
 <20200720092306.355-1-alobakin@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-20_09:2020-07-20,2020-07-20 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Joe,

From: Joe Perches <joe@perches.com>
Date: Mon, 20 Jul 2020 08:19:52 -0700

> On Mon, 2020-07-20 at 12:23 +0300, Alexander Lobakin wrote:
>> Date: Sun, 19 Jul 2020 23:21:00 +0200 From: Andrew Lunn <andrew@lunn.ch>
>>> On Sun, Jul 19, 2020 at 11:14:40PM +0300, Alexander Lobakin wrote:
>>>> Currently qed driver already ran out of 32 bits to store link modes,
>>>> and this doesn't allow to add and support more speeds.
>>>> Convert link mode to bitmap that will always have enough space for
>>>> any number of speeds and modes.
> []
>>> Why not just throw away all these QED_LM_ defines and use the kernel
>>> link modes? The fact you are changing the u32 to a bitmap suggests the
>>> hardware does not use them.
>> 
>> I've just double-checked, and you're right, management firmware operates
>> with NVM_* definitions, while QED_LM_* are used only in QED and QEDE to
>> fill Ethtool link settings.
>> I didn't notice this while working on the series, but it would be really
>> a lot better to just use generic definitions.
>> So I'll send v3 soon.
>
> While you're at it, why are you using __set_bit and not set_bit?

Because I'm filling link modes and don't need any atomicity at all.
If you refer linkmode_*() functions [1], they also use non-atomic
variants of bitops.

Al

[1] https://elixir.bootlin.com/linux/v5.8-rc4/source/include/linux/linkmode.h
