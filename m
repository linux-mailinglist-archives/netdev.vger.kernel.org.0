Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39AA1525AF7
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 07:12:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354677AbiEMFLf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 01:11:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231290AbiEMFLd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 01:11:33 -0400
Received: from mx1.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F43C48E6C;
        Thu, 12 May 2022 22:11:29 -0700 (PDT)
Received: from [192.168.0.2] (ip5f5aeb24.dynamic.kabel-deutschland.de [95.90.235.36])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id DBFB461EA1928;
        Fri, 13 May 2022 07:11:25 +0200 (CEST)
Message-ID: <b6da2e5a-eb85-d3cf-d4c3-ca9c0f0c04a4@molgen.mpg.de>
Date:   Fri, 13 May 2022 07:11:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH net v2] net: ftgmac100: Disable hardware checksum on
 AST2600
Content-Language: en-US
To:     Joel Stanley <joel@jms.id.au>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Dylan Hung <dylan_hung@aspeedtech.com>,
        David Wilder <dwilder@us.ibm.com>, netdev@vger.kernel.org,
        openbmc@lists.ozlabs.org, David Wilder <wilder@us.ibm.com>,
        linux-kernel@vger.kernel.org
References: <20220512231938.228651-1-joel@jms.id.au>
From:   Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <20220512231938.228651-1-joel@jms.id.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Joel,


Am 13.05.22 um 01:19 schrieb Joel Stanley:
> The AST2600 when using the i210 NIC over NC-SI has been observed to
> produce incorrect checksum results with specific MTU values. This was
> first observed when sending data across a long distance set of networks.
> 
> On a local network, the following test was performed using a 1MB file of
> random data.
> 
> On the receiver run this script:
> 
>   #!/bin/bash
>   while [ 1 ]; do
>          # Zero the stats
>          nstat -r  > /dev/null
>          nc -l 9899 > test-file
>          # Check for checksum errors
>          TcpInCsumErrors=$(nstat | grep TcpInCsumErrors)
>          if [ -z "$TcpInCsumErrors" ]; then
>                  echo No TcpInCsumErrors
>          else
>                  echo TcpInCsumErrors = $TcpInCsumErrors
>          fi
>   done
> 
> On an AST2600 system:
> 
>   # nc <IP of  receiver host> 9899 < test-file
> 
> The test was repeated with various MTU values:
> 
>   # ip link set mtu 1410 dev eth0
> 
> The observed results:
> 
>   1500 - good
>   1434 - bad
>   1400 - good
>   1410 - bad
>   1420 - good

Sort the values? As some MTUs are good, should a allow list for these 
values be added?

> The test was repeated after disabling tx checksumming:
> 
>   # ethtool -K eth0 tx-checksumming off
> 
> And all MTU values tested resulted in transfers without error.
> 
> An issue with the driver cannot be ruled out, however there has been no
> bug discovered so far.
> 
> David has done the work to take the original bug report of slow data
> transfer between long distance connections and triaged it down to this
> test case.
> 
> The vendor suspects this this is a hardware issue when using NC-SI. The fixes line refers
> to the patch that introduced AST2600 support.

Please wrap the line after 75 characters.

Can the problem be reproduced with QEMU?

> Fixes: 39bfab8844a0 ("net: ftgmac100: Add support for DT phy-handle property")
> Reported-by: David Wilder <wilder@us.ibm.com>
> Signed-off-by: Joel Stanley <joel@jms.id.au>

Should the intel-wired-lan folks be put in Cc?

> ---
> v2 updates the commit message with confirmation form the vendor that

from

> this is a hardware issue, and clarifes why the commit used in the fixes

clarifies

> tag was chosen.
> 
>   drivers/net/ethernet/faraday/ftgmac100.c | 5 +++++
>   1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/net/ethernet/faraday/ftgmac100.c b/drivers/net/ethernet/faraday/ftgmac100.c
> index caf48023f8ea..5231818943c6 100644
> --- a/drivers/net/ethernet/faraday/ftgmac100.c
> +++ b/drivers/net/ethernet/faraday/ftgmac100.c
> @@ -1928,6 +1928,11 @@ static int ftgmac100_probe(struct platform_device *pdev)
>   	/* AST2400  doesn't have working HW checksum generation */
>   	if (np && (of_device_is_compatible(np, "aspeed,ast2400-mac")))
>   		netdev->hw_features &= ~NETIF_F_HW_CSUM;
> +
> +	/* AST2600 tx checksum with NC-SI is broken */

Does ASPEED have an internal bug for this, so should there be new 
revisions of the AST2600, the bug can be fixed?

> +	if (priv->use_ncsi && of_device_is_compatible(np, "aspeed,ast2600-mac"))
> +		netdev->hw_features &= ~NETIF_F_HW_CSUM;
> +

I would fancy a note or even warning about this hardware issue.

>   	if (np && of_get_property(np, "no-hw-checksum", NULL))
>   		netdev->hw_features &= ~(NETIF_F_HW_CSUM | NETIF_F_RXCSUM);
>   	netdev->features |= netdev->hw_features;


Kind regards,

Paul
