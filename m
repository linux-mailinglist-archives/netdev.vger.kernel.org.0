Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 669B5C2DFE
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 09:47:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732853AbfJAHLV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 03:11:21 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:55602 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726157AbfJAHLV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 03:11:21 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.92.2)
        (envelope-from <johannes@sipsolutions.net>)
        id 1iFCJU-0000Pp-PN; Tue, 01 Oct 2019 09:11:12 +0200
Message-ID: <39e879f59ad3b219901839d1511fc96886bf94fb.camel@sipsolutions.net>
Subject: Re: [PATCH net v4 01/12] net: core: limit nested device depth
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Taehee Yoo <ap420073@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>, linux-wireless@vger.kernel.org,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        j.vosburgh@gmail.com, vfalico@gmail.com,
        Andy Gospodarek <andy@greyhouse.net>,
        =?UTF-8?Q?Ji=C5=99=C3=AD_P=C3=ADrko?= <jiri@resnulli.us>,
        sd@queasysnail.net, Roopa Prabhu <roopa@cumulusnetworks.com>,
        saeedm@mellanox.com, manishc@marvell.com, rahulv@marvell.com,
        kys@microsoft.com, haiyangz@microsoft.com,
        Stephen Hemminger <stephen@networkplumber.org>,
        sashal@kernel.org, hare@suse.de, varun@chelsio.com,
        ubraun@linux.ibm.com, kgraul@linux.ibm.com,
        Jay Vosburgh <jay.vosburgh@canonical.com>,
        Cody Schuffelen <schuffelen@google.com>, bjorn@mork.no
Date:   Tue, 01 Oct 2019 09:11:10 +0200
In-Reply-To: <CAMArcTUgcPv+kg5rhw0i2iwX-CiD00v3ZCvw0b_Q0jb_-eo=UQ@mail.gmail.com> (sfid-20190929_130604_910614_D6042236)
References: <20190928164843.31800-1-ap420073@gmail.com>
         <20190928164843.31800-2-ap420073@gmail.com>
         <d1b5d944fef2a2d5875a0f12f3cdc490586da475.camel@sipsolutions.net>
         <CAMArcTUgcPv+kg5rhw0i2iwX-CiD00v3ZCvw0b_Q0jb_-eo=UQ@mail.gmail.com>
         (sfid-20190929_130604_910614_D6042236)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Sorry for the delay.

> These functions are used as a callback function of
> netdev_walk_all_{upper/lower}_dev(). So these return types are needed.

Ah yes, I missed that, sorry.

> Without storing level storing, a walking graph routine is needed only
> once. The routine would work as a nesting depth validator.
> So that the detach routine doesn't need to walk the graph.
> Whereas, in this patch, both attach and detach routine need to
> walk graph. So, storing nesting variable way is slower than without
> storing nesting variable way because of the detach routine's updating
> upper and lower level routine.

Right, that's what I thought.

> But I'm sure that storing nesting variables is useful because other
> modules already using nesting level values.
> Please look at vlan_get_encap_level() and usecases.

Indeed, I noticed that later.

> If we don't provide nesting level variables, they should calculate
> every time when they need it and this way is easier way to get a
> nesting level. There are use-cases of lower_level variable
> in the 11th patch.

Yes, makes sense, agree. One could argue that you only ever need the
"lower_level" stored, not the "upper_level", but I guess that doesn't
really make a difference.

Placing these in a better position in the struct might make sense - a
cursory look suggested that they weren't filling any of the many holes
there, did you pay attention to that or was the placement more or less
random?

johannes

