Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CA0520523F
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 14:17:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732590AbgFWMRs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 08:17:48 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:33782 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732396AbgFWMRs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 08:17:48 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05NCFFxI028535;
        Tue, 23 Jun 2020 05:17:43 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0818;
 bh=w46+JEbvwbBqOW98veqVwXnnBMl+yKzcoiOAE6Vbm/g=;
 b=htCkGGHgnrHHae6V635l0aWbZHM9JnCGRDnxpTVLywsM3nj75uD6qOruGXmFTwvCua+I
 J8/HJHTonor04u63nxzWHRN3PECKpMUHg2K4NGpgAjXEoBOlUwS1FBM6yxQZm8Tvt1oM
 P1YR+JpU6vySJcC70sdbvVyhq4ICvWiLAl3B9IdZTpQOuacWa9VlSF+gDI2Ubw4ROqh9
 TKgixdQv+29Vp2MyhZk4QDwfNFj/6B7kGfFAUNkH8LdLeG7l5EZaByO9g7MLkzd6vdvO
 RIv5+izDtMUuxzienmORRhjmMKk2bUCrPeg5MhajRy/ZXepq4ZPxdgGanzmHrrxSG8ZZ XA== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0b-0016f401.pphosted.com with ESMTP id 31shynw6ed-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 23 Jun 2020 05:17:43 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 23 Jun
 2020 05:17:41 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 23 Jun 2020 05:17:41 -0700
Received: from NN-LT0049.marvell.com (NN-LT0049.marvell.com [10.193.39.36])
        by maili.marvell.com (Postfix) with ESMTP id A32173F7040;
        Tue, 23 Jun 2020 05:17:37 -0700 (PDT)
From:   Alexander Lobakin <alobakin@marvell.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Alexander Lobakin <alobakin@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Igor Russkikh <irusskikh@marvell.com>,
        Michal Kalderon <michal.kalderon@marvell.com>,
        Ariel Elior <aelior@marvell.com>,
        Yuval Mintz <yuval.mintz@marvell.com>,
        Denis Bolotin <denis.bolotin@marvell.com>,
        "Ram Amrani" <ram.amrani@marvell.com>,
        Tomer Tayar <tomer.tayar@marvell.com>,
        <GR-everest-linux-l2@marvell.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net 9/9] net: qed: fix "maybe uninitialized" warning
Date:   Tue, 23 Jun 2020 15:16:53 +0300
Message-ID: <20200623121652.2511-1-alobakin@marvell.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200622144437.770e09e0@kicinski-fedora-PC1C0HJN>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-23_06:2020-06-23,2020-06-23 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>
Date: Mon, 22 Jun 2020 14:44:37 -0700

> On Mon, 22 Jun 2020 14:14:13 +0300 Alexander Lobakin wrote:
> > Variable 'abs_ppfid' in qed_dev.c:qed_llh_add_mac_filter() always gets
> > printed, but is initialized only under 'ref_cnt == 1' condition. This
> > results in:
> > 
> > In file included from ./include/linux/kernel.h:15:0,
> >                  from ./include/asm-generic/bug.h:19,
> >                  from ./arch/x86/include/asm/bug.h:86,
> >                  from ./include/linux/bug.h:5,
> >                  from ./include/linux/io.h:11,
> >                  from drivers/net/ethernet/qlogic/qed/qed_dev.c:35:
> > drivers/net/ethernet/qlogic/qed/qed_dev.c: In function 'qed_llh_add_mac_filter':
> > ./include/linux/printk.h:358:2: warning: 'abs_ppfid' may be used uninitialized
> > in this function [-Wmaybe-uninitialized]
> >   printk(KERN_NOTICE pr_fmt(fmt), ##__VA_ARGS__)
> >   ^~~~~~
> > drivers/net/ethernet/qlogic/qed/qed_dev.c:983:17: note: 'abs_ppfid' was declared
> > here
> >   u8 filter_idx, abs_ppfid;
> >                  ^~~~~~~~~
> > 
> > ...under W=1+.
> > 
> > Fix this by initializing it with zero.
> > 
> > Fixes: 79284adeb99e ("qed: Add llh ppfid interface and 100g support for
> > offload protocols")
> > Signed-off-by: Alexander Lobakin <alobakin@marvell.com>
> > Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
> > Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
> 
> Please don't wrap Fixes tags:

Aww, second time in a row I fail on this. Sorry, will send v2
soon.

> Fixes tag: Fixes: 79284adeb99e ("qed: Add llh ppfid interface and 100g support for
> Has these problem(s):
> 	- Subject has leading but no trailing parentheses
> 	- Subject has leading but no trailing quotes

Al
