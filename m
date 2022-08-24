Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D5445A0369
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 23:50:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238726AbiHXVua (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 17:50:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238715AbiHXVu2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 17:50:28 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2BF74E845;
        Wed, 24 Aug 2022 14:50:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
        Resent-Message-ID:In-Reply-To:References;
        bh=ea72jXn4qCwy1jlxXBuPqKsWGEHBoJlLe6ksUrb7XRo=; t=1661377828; x=1662587428; 
        b=p9ZTuOUrOkgT1V5Ozcja5FY0onyP+MEBLgcZ15HnvTKqxME6wMYOXhzrfr3BcRpgCIxvc66vF4D
        sJ5wXxYDQ0uxb8JejTm20GSm99kRYpGKJH1AsSsIuFVKSTsga/vsfgCXllUHIpmUUcznl7DqmZVZa
        ZKcNOWLmghYZbEe//e0Tt5LZEviemp8awsT1SW4RtziGof3mKqXm1OKP889WStlBQ+y/vC53MXPVA
        RzWIawGpS7VBXF+KuEaJOwWrMklTsLYLYxERJVndkU8lwUWkbSTUkJ1Fj8/l+BAAl/RMQba0/Npki
        Aj29aKlEaxdCHBMayC74JK8A2SQSyjqBakpg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1oQyGR-00GND3-2X;
        Wed, 24 Aug 2022 23:50:19 +0200
Message-ID: <117aa7ded81af97c7440a9bfdcdf287de095c44f.camel@sipsolutions.net>
Subject: taprio vs. wireless/mac80211
From:   Johannes Berg <johannes@sipsolutions.net>
To:     netdev@vger.kernel.org
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>,
        Avi Stern <avraham.stern@intel.com>,
        linux-wireless@vger.kernel.org
Date:   Wed, 24 Aug 2022 23:50:18 +0200
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-1.fc36) 
MIME-Version: 1.0
X-malware-bazaar: not-scanned
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

We're exploring the use of taprio with wireless/mac80211, and in
mac80211 today (**) we don't have multiple queues (any more) since all
the queuing actually happens in FQ/Codel inside mac80211. We also set
IFF_NO_QUEUE, but that of course only really affects the default qdisc,
not the fact that you could use it or not.

In mac80211 thus we never back-pressure against the qdiscs, which is why
we basically selected a single queue. Also, there's nothing else we do
about the queue other than immediately pull a packet from it if
available, so it'd basically pure overhead to have real queues there.

In a sense, given that we cannot back-pressure against the queues, it
feels a bit wrong to even have multiple queues. We also don't benefit in
any way from splitting data structures onto multiple CPUs or something
since we put it all into the same FQ/Codel anyway.


Now, in order to use taprio, you're more or less assuming that you have
multiple (equivalent) queues, as far as I can tell.


Obviously we can trivially expose multiple equivalent queues from
mac80211, but it feels somewhat wrong if that's just to make taprio be
able to do something?

Also how many should we have, there's more code to run so in many cases
you probably don't want more than one, but if you want to use taprio you
need at least two, but who says that's good enough, you might want more
classes:

        /* taprio imposes that traffic classes map 1:n to tx queues */
        if (qopt->num_tc > dev->num_tx_queues) {
                NL_SET_ERR_MSG(extack, "Number of traffic classes is
greater than number of HW queues");
                return -EINVAL;
        }


The way taprio is done almost feels like maybe it shouldn't even care
about the number of queues since taprio_dequeue_soft() anyway only
queries the sub-qdiscs? I mean, it's scheduling traffic, if you over-
subscribe and send more than the link can handle, you've already lost
anyway, no?

(But then Avi pointed out that the sub qdiscs are initialized per HW
queue, so this doesn't really hold either ...)


Anyone have recommendations what we should do?


Thanks,
johannes


(**) Assuming internal TXQ usage, but let's do that, we even have a
first patch somewhere that converts everything to use it; otherwise we
used to have the queues mapped to the ACs with ndo_select_queue, which
is also quite wrong from this perspective.
