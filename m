Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC80F2DA40
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 12:20:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726097AbfE2KTy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 06:19:54 -0400
Received: from smtprelay-out1.synopsys.com ([198.182.47.102]:41906 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725894AbfE2KTy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 06:19:54 -0400
Received: from mailhost.synopsys.com (dc2-mailhost2.synopsys.com [10.12.135.162])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 9A355C0B5D;
        Wed, 29 May 2019 10:20:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1559125202; bh=CMy51JE8T+YPenb1ih3A8dtRDeJ83erB+4fJTh+U8/I=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=N+lR0n52tLvat1+WG/X4JISGvOtS1Sm55Q+e2sAkGNFUNMF75xeqUbxQY4tX1nEe4
         gQ6gbpelkRJnIxRFuypeb8cfKZ5IOstARV09dNKa9GanFdBYQLar7+1PJFVDOSsW1G
         loTgQNWIpfmMtzIJ4iE1EmrTeI+ZvI0jZ498eVzeTYE1HRzYfBllly5GKrH+TrvMA3
         d2imQ2CMERdzV1nTmNA2blX1I6o7GAymmRu7D0h70ek2EadD79BE/1rB6IOJY3i7Ql
         +L5slKX07+h/LvMqFQB/m2R2o7JPvz0jCp6VX5xttlHL2iqEcXhkk5rAn0yBaLZzo7
         fzTEwInWq7k5A==
Received: from US01WEHTC2.internal.synopsys.com (us01wehtc2.internal.synopsys.com [10.12.239.237])
        (using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id D09C0A0093;
        Wed, 29 May 2019 10:19:51 +0000 (UTC)
Received: from DE02WEHTCA.internal.synopsys.com (10.225.19.92) by
 US01WEHTC2.internal.synopsys.com (10.12.239.237) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Wed, 29 May 2019 03:19:51 -0700
Received: from DE02WEMBXB.internal.synopsys.com ([fe80::95ce:118a:8321:a099])
 by DE02WEHTCA.internal.synopsys.com ([::1]) with mapi id 14.03.0415.000; Wed,
 29 May 2019 12:19:49 +0200
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     Voon Weifeng <weifeng.voon@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Giuseppe Cavallaro" <peppe.cavallaro@st.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "Florian Fainelli" <f.fainelli@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        biao huang <biao.huang@mediatek.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Kweh Hock Leong <hock.leong.kweh@intel.com>
Subject: RE: [PATCH net-next v4 2/5] net: stmmac: introducing support for
 DWC xPCS logics
Thread-Topic: [PATCH net-next v4 2/5] net: stmmac: introducing support for
 DWC xPCS logics
Thread-Index: AQHVFfyhBPDZHqmVr0ee5rETl2X1rKaB4+Pw
Date:   Wed, 29 May 2019 10:19:48 +0000
Message-ID: <78EB27739596EE489E55E81C33FEC33A0B9333E2@DE02WEMBXB.internal.synopsys.com>
References: <1559149107-14631-1-git-send-email-weifeng.voon@intel.com>
 <1559149107-14631-3-git-send-email-weifeng.voon@intel.com>
In-Reply-To: <1559149107-14631-3-git-send-email-weifeng.voon@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.107.19.176]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Voon Weifeng <weifeng.voon@intel.com>
Date: Wed, May 29, 2019 at 17:58:24

> +/* Helpers for DW xPCS */
> +struct stmmac_xpcs {
> +	void (*xpcs_init)(struct net_device *ndev, int pcs_mode);
> +	void (*xpcs_ctrl_ane)(struct net_device *ndev, bool ane, bool loopback)=
;
> +	void (*xpcs_get_adv_lp)(struct net_device *ndev, struct rgmii_adv *adv,
> +				int pcs_mode);
> +	int (*xpcs_irq_status)(struct net_device *ndev,
> +			       struct stmmac_extra_stats *x, int pcs_mode);
> +};

Please rename the structure to stmmac_xpcs_ops, to keep consistency with=20
other helpers.

Thanks,
Jose Miguel Abreu
