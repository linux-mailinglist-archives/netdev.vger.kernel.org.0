Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BAEEDD5A8
	for <lists+netdev@lfdr.de>; Sat, 19 Oct 2019 02:04:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403805AbfJSADw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 20:03:52 -0400
Received: from gate.crashing.org ([63.228.1.57]:50059 "EHLO gate.crashing.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730521AbfJSADw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Oct 2019 20:03:52 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
        by gate.crashing.org (8.14.1/8.14.1) with ESMTP id x9J038G6009788;
        Fri, 18 Oct 2019 19:03:10 -0500
Message-ID: <0ef567e985ce3fe821cbd80265f85a35d16be373.camel@kernel.crashing.org>
Subject: Re: [PATCH v2] ftgmac100: Disable HW checksum generation on AST2500
From:   Benjamin Herrenschmidt <benh@kernel.crashing.org>
To:     Vijay Khemka <vijaykhemka@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        Sven Van Asbroeck <TheSven73@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Bhupesh Sharma <bhsharma@redhat.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc:     "openbmc @ lists . ozlabs . org" <openbmc@lists.ozlabs.org>,
        "joel@jms.id.au" <joel@jms.id.au>,
        "linux-aspeed@lists.ozlabs.org" <linux-aspeed@lists.ozlabs.org>,
        Sai Dasari <sdasari@fb.com>
Date:   Sat, 19 Oct 2019 11:03:08 +1100
In-Reply-To: <529EF9B4-DFDE-4DB7-BE26-3AED8D814134@fb.com>
References: <20191011213027.2110008-1-vijaykhemka@fb.com>
         <3a1176067b745fddfc625bbd142a41913ee3e3a1.camel@kernel.crashing.org>
         <0C0BC813-5A84-403F-9C48-9447AAABD867@fb.com>
         <071cf1eeefcbfc14633a13bc2d15ad7392987a88.camel@kernel.crashing.org>
         <9AA81274-01F2-4803-8905-26F0521486CE@fb.com>
         <f6d5cb45a9aa167533135c5b218b45b1d210d31a.camel@kernel.crashing.org>
         <529EF9B4-DFDE-4DB7-BE26-3AED8D814134@fb.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2019-10-18 at 22:50 +0000, Vijay Khemka wrote:
> I don't have much understanding of IP Stack but I went through code details and 
> you are right and found that it should fallback to SW calculation for IPV6 but it doesn't
> happen because ftgmac100_hard_start_xmit checks for CHECKSUM_PARTIAL before
> setting HW checksum and calling ftgmac100_prep_tx_csum function. And in my 
> understanding, this value is set CHECKSUM_PARTIAL in IP stack. I looked up IP stack for
> IPV6, file net/ipv6/ip6_output.c, function __ip6_append_data: here it sets 
> CHECKSUM_PARTIAL only for UDP packets not for TCP packets. Please look at line
>  number 1880. This could be an issue we are seeing here as why
> ftgmac100_prep_tx_csum is not getting triggered for IPV6 with TCP. Please correct
> me if my understanding is wrong.
>     

Not entirely sure. tcp_v6_send_response() in tcp_ipv6.c does set
CHECKSUM_PARTIAL as well. I don't really know how things are being
handled in that part of the network stack though.

From a driver perspective, if the value of ip_summed is not
CHECKSUM_PARTIAL it means we should not have to calculate any checksum.
At least that's my understanding here.

You may need to add some traces to the driver to see what you get in
there, what protocol indication etc... and analyze the corresponding
packets with something like tcpdump or wireshark on the other end.

Cheers,
Ben.


