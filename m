Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 596672CD17C
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 09:42:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388337AbgLCIl6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 03:41:58 -0500
Received: from fllv0016.ext.ti.com ([198.47.19.142]:42764 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388270AbgLCIlz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 03:41:55 -0500
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 0B38eq0B114050;
        Thu, 3 Dec 2020 02:40:52 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1606984852;
        bh=pz6uUoqgOBRCAt9fEefTV7fWl8JCGohZTi6KZaMZyxo=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=ImxfHlwn86cBcLHD9fwuH+nNsLweSCh+LdiadVYVK9Ix4l9HXlhj1GtDRkuBQcFF1
         OQmlJRCILUwW2iwctM6MCyJgdNmylSGRyVdLvP6h8agbO/Uwrms0KdD3iwW3dq3wms
         1ukKtJ1PpBYjA1dcGQvZ6mVQsZG+vhJMRadkS1hA=
Received: from DFLE114.ent.ti.com (dfle114.ent.ti.com [10.64.6.35])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 0B38eqsQ059694
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 3 Dec 2020 02:40:52 -0600
Received: from DFLE108.ent.ti.com (10.64.6.29) by DFLE114.ent.ti.com
 (10.64.6.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Thu, 3 Dec
 2020 02:40:52 -0600
Received: from lelv0326.itg.ti.com (10.180.67.84) by DFLE108.ent.ti.com
 (10.64.6.29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Thu, 3 Dec 2020 02:40:52 -0600
Received: from [10.250.233.179] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 0B38emBI063771;
        Thu, 3 Dec 2020 02:40:49 -0600
Subject: Re: [PATCH 1/4] net: ti: am65-cpsw-nuss: Add devlink support
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Jonathan Corbet <corbet@lwn.net>, Jiri Pirko <jiri@nvidia.com>,
        <netdev@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Linux ARM Mailing List <linux-arm-kernel@lists.infradead.org>
References: <20201130082046.16292-1-vigneshr@ti.com>
 <20201130082046.16292-2-vigneshr@ti.com> <20201130155044.GE2073444@lunn.ch>
From:   Vignesh Raghavendra <vigneshr@ti.com>
Message-ID: <cc7fe740-1002-f1b9-8136-e1ba60cf2541@ti.com>
Date:   Thu, 3 Dec 2020 14:10:48 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201130155044.GE2073444@lunn.ch>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On 11/30/20 9:20 PM, Andrew Lunn wrote:
> On Mon, Nov 30, 2020 at 01:50:43PM +0530, Vignesh Raghavendra wrote:
>> AM65 NUSS ethernet switch on K3 devices can be configured to work either
>> in independent mac mode where each port acts as independent network
>> interface (multi mac) or switch mode.
>>
>> Add devlink hooks to provide a way to switch b/w these modes.
> 
> Hi Vignesh
> 
> What is not clear is why you need this? Ports are independent anyway
> until you add them to a bridge when using switchdev.
> 

Default use case is to support multiple independent ports with no
switching. Users can either use software bridge with multi-mac
configuration or HW bridge for switch functionality. devlink hook
enables users to select Hw supported switch functionality. We don't want
to enable HW based switch support unless explicitly asked by user.
This also matches previous generation of devices (DRA7xx and AM57xx)
supported under drivers/net/ethernet/ti/cpsw_new.c

In general, devlink will also be used to configure few more parameters
(in addition to switch mode) such as host port in ALE_BYPASS mode (to
allow all packets to be routed to host) etc.

Regards
Vignesh
