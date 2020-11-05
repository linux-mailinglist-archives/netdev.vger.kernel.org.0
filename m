Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFF562A8842
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 21:42:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732176AbgKEUmH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 15:42:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:44748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731234AbgKEUmH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Nov 2020 15:42:07 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 84661206F7;
        Thu,  5 Nov 2020 20:42:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604608926;
        bh=gcniyV4BLIOdDD2xhp++Udmuw/hzW6PcHHy7tEZfv4Y=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ffEqWGOHT6yhDNYGQz03MfWqeypVqAPk9Hisq0JVRyZ9RvnseqFLW7qH/G8eKKMUc
         Y2PlqAOCCMxn1KyPF2Rrw0sGleWH+zzrSQEjrZhStqTkYGKSbBq/Y2zEgsY2/D4Wfa
         latkZbUby7M2e6cd3cXxnjqAdYLiC15V3OQdBj8U=
Date:   Thu, 5 Nov 2020 12:42:04 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     George Cherian <gcherian@marvell.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jiri Pirko <jiri@nvidia.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        Geethasowjanya Akula <gakula@marvell.com>,
        "masahiroy@kernel.org" <masahiroy@kernel.org>,
        "willemdebruijn.kernel@gmail.com" <willemdebruijn.kernel@gmail.com>
Subject: Re: [PATCH v2 net-next 3/3] octeontx2-af: Add devlink health
 reporters for NIX
Message-ID: <20201105124204.4dbea042@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <011c4d4e2227df793f615b7638165c266763e24a.camel@kernel.org>
References: <BYAPR18MB2679EC3507BD90B93B37A3F8C5EE0@BYAPR18MB2679.namprd18.prod.outlook.com>
        <20201105090724.761a033d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <011c4d4e2227df793f615b7638165c266763e24a.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 05 Nov 2020 11:23:54 -0800 Saeed Mahameed wrote:
> If you report an error without recovering, devlink health will report a
> bad device state
> 
> $ ./devlink health
>    pci/0002:01:00.0:
>      reporter npa
>        state error error 1 recover 0

Actually, the counter in the driver is unnecessary, right? Devlink
counts errors.
 
> So you will need to implement an empty recover op.
> so if these events are informational only and they don't indicate
> device health issues, why would you report them via devlink health ?

I see devlink health reporters a way of collecting errors reports which
for the most part are just shared with the vendor. IOW firmware (or
hardware) bugs.

Obviously as you say without recover and additional context in the
report the value is quite diminished. But _if_ these are indeed "report
me to the vendor" kind of events then at least they should use our
current mechanics for such reports - which is dl-health.

Without knowing what these events are it's quite hard to tell if
devlink health is an overkill or counter is sufficient.

Either way - printing these to the logs is definitely the worst choice
:)
