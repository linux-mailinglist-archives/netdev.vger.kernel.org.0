Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E5906E441C
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 11:39:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230231AbjDQJjX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 05:39:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230370AbjDQJjD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 05:39:03 -0400
Received: from h2.cmg1.smtp.forpsi.com (h2.cmg1.smtp.forpsi.com [81.2.195.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CD7B44B2
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 02:38:14 -0700 (PDT)
Received: from lenoch ([91.218.190.200])
        by cmgsmtp with ESMTPSA
        id oLIFpknAFPm6CoLIGpSh4V; Mon, 17 Apr 2023 11:37:06 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=triops.cz; s=f2019;
        t=1681724226; bh=fiuH0GcWevmCpKJ/ebsllotu+6NfmGBkbeZMX+tvMQw=;
        h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
        b=XbifxrbHWa2akLpHL77M7J1IM1oSZf+O6kgZMCP1i+0mQuC2kJqxOcxzkyvBQXSO5
         lCi1eVtUkNP9ylcEIxw9cWQjUptigbtxRyyF5eXGAlm24u1hYvJ3ICK303jgctEh0j
         /lNb4201QskdA5dpv81MZzSoHXjVtN1Z4JiEtWhlJrb/c8zkNox0ObktjQNFO8lC4z
         zcfpe7iX3US2H7mfVn5JLi6VWqyGWSQT2a1zxKgSvqaO7dy0v1bE1vCTu5Z3rHECUt
         gM/qksVzsq2KtWVbZL4l5/LqvEwdAsa356YwMvlY6iWwfK5w2vsZW6KWgjc+JKSXiE
         APkGYz9mdAsNA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=triops.cz; s=f2019;
        t=1681724226; bh=fiuH0GcWevmCpKJ/ebsllotu+6NfmGBkbeZMX+tvMQw=;
        h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
        b=XbifxrbHWa2akLpHL77M7J1IM1oSZf+O6kgZMCP1i+0mQuC2kJqxOcxzkyvBQXSO5
         lCi1eVtUkNP9ylcEIxw9cWQjUptigbtxRyyF5eXGAlm24u1hYvJ3ICK303jgctEh0j
         /lNb4201QskdA5dpv81MZzSoHXjVtN1Z4JiEtWhlJrb/c8zkNox0ObktjQNFO8lC4z
         zcfpe7iX3US2H7mfVn5JLi6VWqyGWSQT2a1zxKgSvqaO7dy0v1bE1vCTu5Z3rHECUt
         gM/qksVzsq2KtWVbZL4l5/LqvEwdAsa356YwMvlY6iWwfK5w2vsZW6KWgjc+JKSXiE
         APkGYz9mdAsNA==
Date:   Mon, 17 Apr 2023 11:37:02 +0200
From:   Ladislav Michl <oss-lists@triops.cz>
To:     Dan Carpenter <error27@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, linux-staging@lists.linux.dev,
        netdev@vger.kernel.org, linux-mips@vger.kernel.org,
        Chris Packham <chris.packham@alliedtelesis.co.nz>
Subject: Re: [PATCH 2/3] staging: octeon: avoid needless device allocation
Message-ID: <ZD0TPvDa7zopm0dx@lenoch>
References: <ZDgNexVTEfyGo77d@lenoch>
 <ZDgOLHw1IkmWVU79@lenoch>
 <543bfbb6-af60-4b5d-abf8-0274ab0b713f@lunn.ch>
 <ZDgxPet9RIDC9Oz1@lenoch>
 <e2f5462d-5573-483c-9428-5f2b052cf939@lunn.ch>
 <26dd05e9-befa-4190-ac3c-bf31d58a5f1e@kili.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <26dd05e9-befa-4190-ac3c-bf31d58a5f1e@kili.mountain>
X-CMAE-Envelope: MS4wfEZoGX5SjGjVN9HkENAmeGDGDqi/iG6ZWS3FtNZ+NfpDCsvAiEsGbJG0frJEQz+t3qh3s9ZgEjxgF4rr/tt8EqHHyu4w5ezF4oieB+uDA7J22lrYoAGe
 3L3zavGD6+BrPIeUKPRcvvcRCgOIEhYg25QqzUmq6cXBpG/W5GBY9yPCsWhw37E6k8MRpCdL3GaLMZyuVxRotSrWoPnIgLwzPFKFe3+lW5M/w2N9+4BKMQVa
 07VstyGTle8yMFw/xvD6zh6CH/X8rIs7j/56AAOZovAb6EJ98qs/4yUvFOaMscg9ZNA4t8hJgCZ6Pskc1s88eDjykwdeEeLc8h7qhy5aC7VxXic6hFf/npmA
 1Q8ZoCPz
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 17, 2023 at 11:37:30AM +0300, Dan Carpenter wrote:
> On Thu, Apr 13, 2023 at 07:20:08PM +0200, Andrew Lunn wrote:
> > > I was asking this question myself and then came to this:
> > > Converting driver to phylink makes separating different macs easier as
> > > this driver is splitted between staging and arch/mips/cavium-octeon/executive/
> > > However I'll provide changes spotted previously as separate preparational
> > > patches. Would that work for you?
> > 
> > Is you end goal to get this out of staging? phylib vs phylink is not a
> > reason to keep it in staging.
> > 
> > It just seems odd to be adding new features to a staging driver. As a
> > bit of a "carrot and stick" maybe we should say you cannot add new
> > features until it is ready to move out of staging?
> 
> We already have that rule.  But I don't know anything about phy vs
> phylink...

Let me elaborate here a bit then.

Current Octeon driver comes from Cavium's vendor kernel tree. Cavium
started this about two decades ago based on their own ideas and tries
to bend kernel interfaces around them.

Driver is based aroud Packet Input Processing/Input Packet Data (PIP/IPD)
units which can connect their data streams to various interfaces.
SGMII/1000BASE-X/QSGMII and RGMII are just two of them.

Currently driver iterates over all interfaces and all ports to bind
interfaces to PIP/IPD. There is a lot of code deciding which
interfaces/ports exits on given Octeon SoC, see
arch/mips/cavium-octeon/executive/
Driver code then calls those helpers with interface/port aguments
and they do the magic using switches deciding what to do based
on interface type.

I'm proposing to leave all that trickery behind and just follow what's
written in device tree, so each I/O interface ends up as a driver
with its own mac ops. While it is possible to implement that as
private mac ops as some other drivers do, I think it is more
convenient to use phylink_mac_ops.

In case I'm missing something or I'm wrong with analysis, please let
me know.

Thanks,
	ladis
