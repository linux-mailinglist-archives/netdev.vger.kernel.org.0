Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D697667AB3
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 17:25:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233379AbjALQZD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 11:25:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232994AbjALQYd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 11:24:33 -0500
Received: from netgeek.ovh (ks.netgeek.ovh [IPv6:2001:41d0:a:271e::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4368518B00;
        Thu, 12 Jan 2023 08:21:09 -0800 (PST)
Received: from quaddy.sgn (unknown [IPv6:2a01:cb19:83f8:d500:21d:60ff:fedb:90ab])
        by ks.netgeek.ovh (Postfix) with ESMTPSA id 9E77C152;
        Thu, 12 Jan 2023 17:21:08 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=netgeek.ovh;
        s=default; t=1673540468;
        bh=7JnEnSkCbq3mxD56KLZrGRldLIdlGmpduZ9f8M+VY8E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To;
        b=lMWweUshTT9AjcVX7IJQen/0GjWFm+1C3pS2EG06O58Hx87+Lq1OWIldzyyNtOoV3
         DXLMa8rBMcYCwZ2anG8QiBR3Qc3JYnvJy5rwMp09zTHDbQGnmgoejD40yR1mJ97nE7
         CuD3VmS8WvyBnSj1OiZX3Ic5mhOTdkQc6lSL1jy4ryYgpC/6DafPwhSLMddqphbvh1
         fvTpO1VqTtP8GQM96zCFu0LPfwky2L9VnMLfC/Fdyt8ZpHnlCcD8VU2OP0uOWAXDRZ
         9vvivreT/i/Jp+fEuThqXFbg3YreY/zaAjtu6XZnjNs/L5sR3lXsCckLhM/SaQywr4
         qv7jRaM+H47jA==
Date:   Thu, 12 Jan 2023 17:22:34 +0100
From:   =?iso-8859-1?Q?Herv=E9?= Boisse <admin@netgeek.ovh>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, admin@netgeek.ovh,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net 2/2] net/af_packet: fix tx skb network header on
 SOCK_RAW sockets over VLAN device
Message-ID: <Y8AzypbpgDOSzhz6@quaddy.sgn>
References: <20230110191725.22675-1-admin@netgeek.ovh>
 <20230110191725.22675-2-admin@netgeek.ovh>
 <fa5895ae62e0f9c1eb8f662295ca920d1da7e88f.camel@redhat.com>
 <Y8Am5wAxC48N12PE@quaddy.sgn>
 <47d9b00c664dbaabd8921a47257ffc3b7c5a1325.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <47d9b00c664dbaabd8921a47257ffc3b7c5a1325.camel@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 12, 2023 at 04:47:38PM +0100, Paolo Abeni wrote:
> I understand, thanks. Still is not clear why the user-space application
> would attach to dummy0.832 instead of dummy0.
> 
> With your patch the filter will match, but the dhcp packet will reach
> the wire untagged, so the app will behave exactly as it would do
> if/when attached to dummy0.
> 
> To me it looks like the dhcp client has a bad configuration (wrong
> interface) and these patches address the issue in the wrong place
> (inside the kernel).

No, the packet will actually reach the wire as a properly tagged 802.1Q frame.
For devices that do not support VLAN offloading (such as dummy but also the network card I am using), the kernel adds the tag itself in software before transmitting the packet to the real device. 

You can verify this with a capture using tcpdump/wireshark on dummy0 versus dummy0.832.
That's why dhclient has to send its packets over dummy0.832 and not dummy0.

The same will happen on a real device. I checked on real hardware, with two boxes and their network cards connected through a cable.
If dhclient is started directly on the first box real device (eth0), the frame is received untagged by the second box, as intended.
But, if dhclient is started on top of the VLAN device (eth0.832), the second box receives a properly tagged frame.

Hervé

