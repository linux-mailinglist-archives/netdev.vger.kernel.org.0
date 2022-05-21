Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CD8252F7C7
	for <lists+netdev@lfdr.de>; Sat, 21 May 2022 04:56:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354390AbiEUCz6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 22:55:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235521AbiEUCz5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 22:55:57 -0400
Received: from gate.crashing.org (gate.crashing.org [63.228.1.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 674F63630F
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 19:55:54 -0700 (PDT)
Received: from ip6-localhost (localhost.localdomain [127.0.0.1])
        by gate.crashing.org (8.14.1/8.14.1) with ESMTP id 24L2pLgB004438;
        Fri, 20 May 2022 21:51:22 -0500
Message-ID: <5630dd68ca5f31dafce3f92489761294ea589b16.camel@kernel.crashing.org>
Subject: Re: [PATCH net v3] net: ftgmac100: Disable hardware checksum on
 AST2600
From:   Benjamin Herrenschmidt <benh@kernel.crashing.org>
To:     Joel Stanley <joel@jms.id.au>, Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Andrew Jeffery <andrew@aj.id.au>
Cc:     netdev@vger.kernel.org, David Wilder <wilder@us.ibm.com>,
        linux-aspeed@lists.ozlabs.org
Date:   Sat, 21 May 2022 12:51:21 +1000
In-Reply-To: <20220517092217.323060-1-joel@jms.id.au>
References: <20220517092217.323060-1-joel@jms.id.au>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2022-05-17 at 18:52 +0930, Joel Stanley wrote:
> The AST2600 when using the i210 NIC over NC-SI has been observed to
> produce incorrect checksum results with specific MTU values. This was
> first observed when sending data across a long distance set of
> networks.
> 
> On a local network, the following test was performed using a 1MB file
> of random data.

Can you double check with Aspeed what's going on there and whether
there's a way to instead, identify the bad case in the TX path and do
on-demand SW checksuming only in those cases ?

Because disabling HW checksum will kill performances afaik... (doesn't
it also end up disabling zero-copy and SG ?)

Cheers,
Ben.

> On the receiver run this script:
> 
>  #!/bin/bash
>  while [ 1 ]; do
>         # Zero the stats
>         nstat -r  > /dev/null
>         nc -l 9899 > test-file
>         # Check for checksum errors
>         TcpInCsumErrors=$(nstat | grep TcpInCsumErrors)
>         if [ -z "$TcpInCsumErrors" ]; then
>                 echo No TcpInCsumErrors
>         else
>                 echo TcpInCsumErrors = $TcpInCsumErrors
>         fi
>  done
> 
> On an AST2600 system:
> 
>  # nc <IP of  receiver host> 9899 < test-file
> 
> The test was repeated with various MTU values:
> 
>  # ip link set mtu 1410 dev eth0
> 
> The observed results:
> 
>  1500 - good
>  1434 - bad
>  1400 - good
>  1410 - bad
>  1420 - good
> 
> The test was repeated after disabling tx checksumming:
> 
>  # ethtool -K eth0 tx-checksumming off
> 
> And all MTU values tested resulted in transfers without error.
> 
> An issue with the driver cannot be ruled out, however there has been
> no
> bug discovered so far.
> 
> David has done the work to take the original bug report of slow data
> transfer between long distance connections and triaged it down to
> this
> test case.
> 
> The vendor suspects this this is a hardware issue when using NC-SI.
> The
> fixes line refers to the patch that introduced AST2600 support.
> 
> Reported-by: David Wilder <wilder@us.ibm.com>
> Reviewed-by: Dylan Hung <dylan_hung@aspeedtech.com>
> Signed-off-by: Joel Stanley <joel@jms.id.au>
> ---
> v3 modifies the wrapping of the commit message.
> 
> v2 updates the commit message with confirmation from the vendor that
> this is a hardware issue, and clarifies why the commit used in the
> fixes
> 
>  drivers/net/ethernet/faraday/ftgmac100.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/net/ethernet/faraday/ftgmac100.c
> b/drivers/net/ethernet/faraday/ftgmac100.c
> index caf48023f8ea..5231818943c6 100644
> --- a/drivers/net/ethernet/faraday/ftgmac100.c
> +++ b/drivers/net/ethernet/faraday/ftgmac100.c
> @@ -1928,6 +1928,11 @@ static int ftgmac100_probe(struct
> platform_device *pdev)
>  	/* AST2400  doesn't have working HW checksum generation */
>  	if (np && (of_device_is_compatible(np, "aspeed,ast2400-mac")))
>  		netdev->hw_features &= ~NETIF_F_HW_CSUM;
> +
> +	/* AST2600 tx checksum with NCSI is broken */
> +	if (priv->use_ncsi && of_device_is_compatible(np,
> "aspeed,ast2600-mac"))
> +		netdev->hw_features &= ~NETIF_F_HW_CSUM;
> +
>  	if (np && of_get_property(np, "no-hw-checksum", NULL))
>  		netdev->hw_features &= ~(NETIF_F_HW_CSUM |
> NETIF_F_RXCSUM);
>  	netdev->features |= netdev->hw_features;

