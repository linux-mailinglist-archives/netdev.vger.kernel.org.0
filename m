Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FC0B429F43
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 10:04:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234883AbhJLIF6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 04:05:58 -0400
Received: from mx3.molgen.mpg.de ([141.14.17.11]:41601 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234873AbhJLIE7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Oct 2021 04:04:59 -0400
Received: from [192.168.0.2] (ip5f5ae924.dynamic.kabel-deutschland.de [95.90.233.36])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id AFE1561E5FE33;
        Tue, 12 Oct 2021 10:02:03 +0200 (CEST)
Subject: Re: [PATCH] net: ncsi: Adding padding bytes in the payload
To:     Kumar Thangavel <kumarthangavel.hcl@gmail.com>
Cc:     Samuel Mendoza-Jonas <sam@mendozajonas.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-aspeed@lists.ozlabs.org, netdev@vger.kernel.org,
        openbmc@lists.ozlabs.org, Amithash Prasad <amithash@fb.com>,
        linux-kernel@vger.kernel.org, velumanit@hcl.com, patrickw3@fb.com
References: <20211012062240.GA5761@gmail.com>
From:   Paul Menzel <pmenzel@molgen.mpg.de>
Message-ID: <e8204e87-5b07-2049-3fdb-23dd8e4e21a6@molgen.mpg.de>
Date:   Tue, 12 Oct 2021 10:02:03 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211012062240.GA5761@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Kumar,


Thank you for your patch.

Nit: Could you please use the imperative mood in the commit message summary:

 > net: ncsi: Add padding bytes in the payload

Or more descriptive:

 > net: ncsi: Padd payload to be 32-bit aligned to fix dropped packets

Am 12.10.21 um 08:22 schrieb Kumar Thangavel:
> Update NC-SI command handler (both standard and OEM) to take into
> account of payload paddings in allocating skb (in case of payload
> size is not 32-bit aligned).
> 
> The checksum field follows payload field, without taking payload
> padding into account can cause checksum being truncated, leading to
> dropped packets.

How can this be reproduced?

> Signed-off-by: Kumar Thangavel <thangavel.k@hcl.com>
> 
> ---
>   net/ncsi/ncsi-cmd.c | 21 +++++++++++++++++----
>   1 file changed, 17 insertions(+), 4 deletions(-)
> 
> diff --git a/net/ncsi/ncsi-cmd.c b/net/ncsi/ncsi-cmd.c
> index ba9ae482141b..4625fc935603 100644
> --- a/net/ncsi/ncsi-cmd.c
> +++ b/net/ncsi/ncsi-cmd.c
> @@ -214,11 +214,19 @@ static int ncsi_cmd_handler_oem(struct sk_buff *skb,
>   	struct ncsi_cmd_oem_pkt *cmd;
>   	unsigned int len;
>   
> +	/* NC-SI spec requires payload to be padded with 0

It’d be great, if you included the specification version, and section if 
the requirement.

> +	 * to 32-bit boundary before the checksum field.
> +	 * Ensure the padding bytes are accounted for in
> +	 * skb allocation
> +	 */
> +

Please remove the blank line.

> +	unsigned short payload = ALIGN(nca->payload, 4);
> +
>   	len = sizeof(struct ncsi_cmd_pkt_hdr) + 4;
> -	if (nca->payload < 26)
> +	if (payload < 26)
>   		len += 26;
>   	else
> -		len += nca->payload;
> +		len += payload;
>   
>   	cmd = skb_put_zero(skb, len);
>   	memcpy(&cmd->mfr_id, nca->data, nca->payload);
> @@ -272,6 +280,7 @@ static struct ncsi_request *ncsi_alloc_command(struct ncsi_cmd_arg *nca)
>   	struct net_device *dev = nd->dev;
>   	int hlen = LL_RESERVED_SPACE(dev);
>   	int tlen = dev->needed_tailroom;
> +	int payload;
>   	int len = hlen + tlen;
>   	struct sk_buff *skb;
>   	struct ncsi_request *nr;
> @@ -281,14 +290,18 @@ static struct ncsi_request *ncsi_alloc_command(struct ncsi_cmd_arg *nca)
>   		return NULL;
>   
>   	/* NCSI command packet has 16-bytes header, payload, 4 bytes checksum.
> +	 * Payload needs padding so that the checksum field follwoing payload is

following

> +	 * aligned to 32bit boundary.

32-bit

>   	 * The packet needs padding if its payload is less than 26 bytes to
>   	 * meet 64 bytes minimal ethernet frame length.
>   	 */
>   	len += sizeof(struct ncsi_cmd_pkt_hdr) + 4;
> -	if (nca->payload < 26)
> +
> +	payload = ALIGN(nca->payload, 4);
> +	if (payload < 26)
>   		len += 26;
>   	else
> -		len += nca->payload;
> +		len += payload;
>   
>   	/* Allocate skb */
>   	skb = alloc_skb(len, GFP_ATOMIC);
> 

Besides the nits, this looks fine to me.


Kind regards,

Paul
