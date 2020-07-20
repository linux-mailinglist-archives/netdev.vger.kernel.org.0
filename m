Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BF60225B65
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 11:23:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728182AbgGTJXs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 05:23:48 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:42004 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727961AbgGTJXr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 05:23:47 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06K963Fj001059;
        Mon, 20 Jul 2020 02:23:37 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0818;
 bh=9Pdq+syVPGsE7NiIyror1875Q3xdqrQ6j+hVF3yHZjg=;
 b=GpfalX26qtABHMyMnlaBzTPipHdhsk1hzqJXVsyAoggEenmtwV2vXAH1lQza9vbkg5K4
 cTVgEuoovRPHhc0cDG/R+yuClPKQogoGUjK1xd0dxzeakTK44GYxn+CHA+cOwEUmK1gQ
 4xGQfJoTym1DJAQmZKTzZggp1Mago54Xn9hU46zgKqSkFW89OQzP8oLocbayARihnPRe
 o6ZyFtG2i0mPii2CrzH8+v5Wji+WXtF+YLmVUxH33vSbHdmGZcSr1oQJ7hqj3vVqvToQ
 Oin3Y0pnW42+hE3AhkQI1GlASHz+SK948L8IhZPl3j+CY4g822NrBKjD0E0p0Oar8dVU BA== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 32c0kkda03-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 20 Jul 2020 02:23:37 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 20 Jul
 2020 02:23:34 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 20 Jul 2020 02:23:34 -0700
Received: from NN-LT0049.marvell.com (NN-LT0049.marvell.com [10.193.54.6])
        by maili.marvell.com (Postfix) with ESMTP id 37CDE3F703F;
        Mon, 20 Jul 2020 02:23:29 -0700 (PDT)
From:   Alexander Lobakin <alobakin@marvell.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Alexander Lobakin <alobakin@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Igor Russkikh <irusskikh@marvell.com>,
        Michal Kalderon <michal.kalderon@marvell.com>,
        "Ariel Elior" <aelior@marvell.com>,
        Denis Bolotin <denis.bolotin@marvell.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        <GR-everest-linux-l2@marvell.com>,
        <QLogic-Storage-Upstream@marvell.com>, <netdev@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 net-next 01/14] qed: convert link mode from u32 to bitmap
Date:   Mon, 20 Jul 2020 12:23:06 +0300
Message-ID: <20200720092306.355-1-alobakin@marvell.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200719212100.GM1383417@lunn.ch>
References: <20200719212100.GM1383417@lunn.ch>
 <20200719201453.3648-1-alobakin@marvell.com>
 <20200719201453.3648-2-alobakin@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-20_05:2020-07-17,2020-07-20 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Date: Sun, 19 Jul 2020 23:21:00 +0200
From: Andrew Lunn <andrew@lunn.ch>

> On Sun, Jul 19, 2020 at 11:14:40PM +0300, Alexander Lobakin wrote:
>> Currently qed driver already ran out of 32 bits to store link modes,
>> and this doesn't allow to add and support more speeds.
>> Convert link mode to bitmap that will always have enough space for
>> any number of speeds and modes.
>
> Hi Alexander

Hi Andrew!

> Why not just throw away all these QED_LM_ defines and use the kernel
> link modes? The fact you are changing the u32 to a bitmap suggests the
> hardware does not use them.

I've just double-checked, and you're right, management firmware operates
with NVM_* definitions, while QED_LM_* are used only in QED and QEDE to
fill Ethtool link settings.
I didn't notice this while working on the series, but it would be really
a lot better to just use generic definitions.
So I'll send v3 soon.

>      Andrew

Thanks,
Al
