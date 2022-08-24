Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB16D59FA11
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 14:34:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236296AbiHXMd7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 08:33:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232039AbiHXMd6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 08:33:58 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 701888E453;
        Wed, 24 Aug 2022 05:33:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=QRXGG0IhUNzmWwnv6Cim5HepItxfwCJgBqcKIXNvnPc=; b=I1JkA6Zr3qxfrFvsOtxbGjw42G
        KxFGgeLCzkf9s1Efcma1CZSJx6VEa1q7jlFgJ8Q9DTy8ZFHyAacwDXQPYotBTlvWOzQrslDDI5mEa
        QJj7W1eS8li8mdDsVFvr6SeBdVu8P9EEPoMzS9TY2IxWFJu7eSBA+02ltHWpwJ4jBhTQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oQpZi-00ERd6-PF; Wed, 24 Aug 2022 14:33:38 +0200
Date:   Wed, 24 Aug 2022 14:33:38 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Suman Ghosh <sumang@marvell.com>
Cc:     Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        Geethasowjanya Akula <gakula@marvell.com>,
        Jerin Jacob Kollanukkaran <jerinj@marvell.com>,
        Hariprasad Kelam <hkelam@marvell.com>,
        Subbaraya Sundeep Bhatta <sbhatta@marvell.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [EXT] Re: [PATCH] octeontx2-pf: Add egress PFC support
Message-ID: <YwYaoqiS/0+N1TU0@lunn.ch>
References: <20220823065829.1060339-1-sumang@marvell.com>
 <YwT3V6A4xrS3jAqf@lunn.ch>
 <SJ0PR18MB52165D5FA51E433CAD0E8CBBDB739@SJ0PR18MB5216.namprd18.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SJ0PR18MB52165D5FA51E433CAD0E8CBBDB739@SJ0PR18MB5216.namprd18.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> >> -	schq = hw->txschq_list[lvl][0];
> >> +#ifdef CONFIG_DCB
> >> +	if (txschq_for_pfc)
> >> +		schq = pfvf->pfc_schq_list[lvl][prio];
> >> +	else
> >> +#endif
> >
> >Please could you try to remove as many of these #ifdef CONFIG_DCB as
> >possible. It makes build testing less efficient at finding build
> >problems. Can you do:
> >
> >> +	if (IS_ENABLED(CONFIG_DCB) && txschq_for_pfc)
> >> +		schq = pfvf->pfc_schq_list[lvl][prio];
> >
> [Suman] I will restructured the code. But we cannot use pfvf->pfc_schq_list outside #ifdef CONFIG_DCB as these are defined under the 
> macro in otx2_common.h

So maybe add a getter and setter in otx2_common.h, which returns
-EOPNOTSUPP or similar when CONFIG_DCB is disabled?

	    Andrew
