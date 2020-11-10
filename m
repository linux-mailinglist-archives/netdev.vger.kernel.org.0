Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D30EA2AD879
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 15:16:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730785AbgKJOQj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 09:16:39 -0500
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:53724 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730306AbgKJOQi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 09:16:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1605017798; x=1636553798;
  h=references:from:to:cc:subject:in-reply-to:date:
   message-id:mime-version;
  bh=/pRG9WstYX5Gt0aV6L+9ZdT/3GXFPr5BMfaefLyPVrY=;
  b=glOriLjIMRv7SLS9jCjrWExu/iM/KI+RGDqUCav1n2VryS9nCRBedJZo
   GzWUtJsyVDzX7ONvnfSxSW6wQM54Mla0vnIt19HDW029H4MCaVMHdinzS
   NVEFXcHuUAZroTqWfC/q7TYtTBeS3ptPkiYyFeXOTfnAETSUSMoItyf+l
   ZwrSLwhIyxoHakfo8nWSovTcMKMwlb6xy3mo5RJoF6ZUQYcrXnOlfbwvX
   5l/dV2zwCWJiGTHIqs4wNAPVLLPt1Q6D2X5jsvYBkfglvebYDFnHwvabE
   fKQUaeAf7XFEDeLxhtgtj4PJm5MeJsSxLDl4zgoWKk1yHBs9QcJGdFOKT
   A==;
IronPort-SDR: NW1f5quH0B5w1KcR/vLZ5MOxdBv5YgfvuD5BYYh/D/c62L7fEXe/1zY3HvhUHnQDBmsWLOkA0I
 JsAiDJHxNpAsD/T48g50EtaaAfbDipFDJ22hBDXO2L5nvUlfebOIUEssu6l1EzI2bdfwBcgGx+
 peE2LJnCBWM6twyin2FEkxGhqsaEDK8Z3iqPoIAZVGMgDkyiEORt3P4vQZphGEKQMrAyKdOSHl
 TsG07Y5YI3/9d2zXmNzKoBOQUHzCiVPEa2wZbikh+7GdVEzZ2Ngu7ZgTyCza8TET8imRoj6TMU
 nP4=
X-IronPort-AV: E=Sophos;i="5.77,466,1596524400"; 
   d="scan'208";a="98449226"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 10 Nov 2020 07:16:37 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 10 Nov 2020 07:16:37 -0700
Received: from soft-dev2.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3
 via Frontend Transport; Tue, 10 Nov 2020 07:16:35 -0700
References: <20201110100642.2153-1-bjarni.jonasson@microchip.com> <20201110102552.GZ1551@shell.armlinux.org.uk>
User-agent: mu4e 0.9.18; emacs 25.2.2
From:   Bjarni Jonasson <bjarni.jonasson@microchip.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
CC:     Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        UNGLinuxDriver <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH] phy: phylink: Fix CuSFP issue in phylink
In-Reply-To: <20201110102552.GZ1551@shell.armlinux.org.uk>
Date:   Tue, 10 Nov 2020 15:16:34 +0100
Message-ID: <87blg5qou5.fsf@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Russell King - ARM Linux admin writes:

> On Tue, Nov 10, 2020 at 11:06:42AM +0100, Bjarni Jonasson wrote:
>> There is an issue with the current phylink driver and CuSFPs which
>> results in a callback to the phylink validate function without any
>> advertisement capabilities.  The workaround (in this changeset)
>> is to assign capabilities if a 1000baseT SFP is identified.
>
> How does this happen?  Which PHY is being used?

This occurs just by plugging in the CuSFP.
None of the CuSFPs we have tested are working.
This is a dump from 3 different CuSFPs, phy regs 0-3:
FS SFP: 01:40:79:49 
HP SFP: 01:40:01:49
Marvel SFP: 01:40:01:49
This was working before the delayed mac config was implemented (in dec
2019).

--
Bjarni Jonasson, Microchip
