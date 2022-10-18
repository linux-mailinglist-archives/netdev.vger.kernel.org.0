Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDF83601FE9
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 02:53:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230111AbiJRAxF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Oct 2022 20:53:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230090AbiJRAxF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 20:53:05 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CC6B8993E
        for <netdev@vger.kernel.org>; Mon, 17 Oct 2022 17:52:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=j/oG9w00Wc+cJ+XTdNzSI4emlTOOBkhMZ4zjBopJSwg=; b=UfXGiZi0eW6ifruue+h7pzDsYT
        mP5K1ednUiFUkOLYrCF7Yif00GhMIZcdSoPcjh5m1apwkv4CBwEiChWfm0+AuPoqMeoKrRNMNZp63
        JFsdDy+NHj7p5cm2UeHOQCC0CqpxkKNau+c8oZnIzSLW+Zhe6i9z+Zm//k2uZEi9tSJI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1okaSK-002Gus-1j; Tue, 18 Oct 2022 02:27:40 +0200
Date:   Tue, 18 Oct 2022 02:27:40 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     =?iso-8859-1?B?zfFpZ28=?= Huguet <ihuguet@redhat.com>
Cc:     irusskikh@marvell.com, dbogdanov@marvell.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, Li Liang <liali@redhat.com>
Subject: Re: [PATCH net] atlantic: fix deadlock at aq_nic_stop
Message-ID: <Y03y/D8WszbjmSwZ@lunn.ch>
References: <20221014103443.138574-1-ihuguet@redhat.com>
 <Y0lSYQ99lBSqk+eH@lunn.ch>
 <CACT4ouct9H+TQ33S=bykygU_Rpb61LMQDYQ1hjEaM=-LxAw9GQ@mail.gmail.com>
 <Y0llmkQqmWLDLm52@lunn.ch>
 <CACT4oudn-sS16O7_+eihVYUqSTqgshbbqMFRBhgxkgytphsN-Q@mail.gmail.com>
 <Y0rNLpmCjHVoO+D1@lunn.ch>
 <CACT4oucrz5gDazdAF3BpEJX8XTRestZjiLAOxSHGAxSqf_o+LQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACT4oucrz5gDazdAF3BpEJX8XTRestZjiLAOxSHGAxSqf_o+LQ@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > Please try to identify what is being protected. If it is driver
> > internal state, could it be replaced with a driver mutex, rather than
> > RTNL? Or is it network stack as a whole state, which really does
> > require RTNL? If so, how do other drivers deal with this problem? Is
> > it specific to MACSEC? Does MACSEC have a design problem?
> 
> I already considered this possibility but discarded it because, as I
> say above, everything else is already legitimately protected by
> rtnl_lock.

Did you look at other drivers using MACSEC offload? Is this driver
unique in having stuff run in a work queue which you need to cancel?
In fact, it is not limited to MACSEC, it could be any work queue which
holds RTNL and needs to be cancelled.

      Andrew

