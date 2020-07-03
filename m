Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD804214224
	for <lists+netdev@lfdr.de>; Sat,  4 Jul 2020 01:58:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726759AbgGCX6I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jul 2020 19:58:08 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:18236 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726379AbgGCX6F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jul 2020 19:58:05 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 063Nw1WZ026868;
        Fri, 3 Jul 2020 16:58:01 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0818;
 bh=bqPoRX4VjkPGoPXE7CWXFKmFFzVZxQZaQqHY37LMe4E=;
 b=xQ+2yOZ0AAhop9P+IE2lsOW/qjmNzoztOlKA/x5D7nSQJtQWFa+WNFF78lxustHcalxv
 jLmv5yjcM5CeuhDLMP372aoF/1lzBRT5f0JSJuJViS+MiYUkN6mET7iz60vE/g3zgGRs
 CPFXRAA9BcMGlKbiagtsuC5W0CfjyMq3nU0OjBRLBCy6CGYoU5Qc/ZKkxdZkjlkhiIH6
 oNpbtJ+UlnspO+UwOGVF6QU0aW+12VUbj9Vf0caeYYYGDFj5KPSbrWcH7ayJJ3haDnM2
 DhlthSqFD6LIDIkklIIf3vsSxCTIzUyZ6vzBX7PnxSFs892u3I6d3P2XDQ8flgdLnd+0 ZA== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 321m92wjgr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 03 Jul 2020 16:58:01 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 3 Jul
 2020 16:58:01 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 3 Jul
 2020 16:58:00 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 3 Jul 2020 16:58:00 -0700
Received: from NN-LT0049.marvell.com (NN-LT0049.marvell.com [10.193.54.6])
        by maili.marvell.com (Postfix) with ESMTP id F1B523F703F;
        Fri,  3 Jul 2020 16:57:56 -0700 (PDT)
From:   Alexander Lobakin <alobakin@marvell.com>
To:     David Miller <davem@davemloft.net>
CC:     Alexander Lobakin <alobakin@marvell.com>, <kuba@kernel.org>,
        <irusskikh@marvell.com>, <michal.kalderon@marvell.com>,
        <aelior@marvell.com>, <denis.bolotin@marvell.com>,
        <GR-everest-linux-l2@marvell.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] net: qed: prevent buffer overflow when collecting debug data
Date:   Sat, 4 Jul 2020 02:57:04 +0300
Message-ID: <20200703235704.266-1-alobakin@marvell.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200703.125933.1255981278532631718.davem@davemloft.net>
References: <20200703.125933.1255981278532631718.davem@davemloft.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-03_18:2020-07-02,2020-07-03 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   David Miller <davem@davemloft.net>
Date:   Fri, 03 Jul 2020 12:59:33 -0700 (PDT)

> From: Alexander Lobakin <alobakin@marvell.com>
> Date: Fri, 3 Jul 2020 12:02:58 +0300
> 
> > When generating debug dump, driver firstly collects all data in binary
> > form, and then performs per-feature formatting to human-readable if it
> > is supported.
> > The size of the new formatted data is often larger than the raw's. This
> > becomes critical when user requests dump via ethtool (-d/-w), as output
> > buffer size is strictly determined (by ethtool_ops::get_regs_len() etc),
> > as it may lead to out-of-bounds writes and memory corruption.
> > 
> > To not go past initial lengths, add a flag to return original,
> > non-formatted debug data, and set it in such cases. Also set data type
> > in regdump headers, so userland parsers could handle it.
> > 
> > Fixes: c965db444629 ("qed: Add support for debug data collection")
> > Signed-off-by: Alexander Lobakin <alobakin@marvell.com>
> > Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
> 
> This is now how ethtool register dumps work.
> 
> It does not provide "human readable" versions of register data.  Instead
> it is supposed to be purely raw data and then userland utilities interpret
> that data and can make it human readable based upon the driver name and
> reg dump version.
> 
> Please fix your ethtool -d implementation to comply with this.

This is exactly what this patch does: forces driver to dump raw binary
data. Current mainline version tries to perform formatting before passing
data up to ethtool infra.

> Thank you.

Thanks,
Al
