Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C88544C2A0
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 14:58:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232080AbhKJOBM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 09:01:12 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:45892 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232057AbhKJOBL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Nov 2021 09:01:11 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id B974E21B04;
        Wed, 10 Nov 2021 13:58:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1636552702; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sXZTBdeyVQwbfHLEl2Qd3oJBHCIZMitnb/RbNeAIjJY=;
        b=wRJDhtBuSOeZmDM6u2YhE+0EazYL98T1jy6Fhz3o6OlW9TUjVnLcMFogEkXtW7FBgwSZN9
        lru9gEpad175upns/O5IieuPSn23BB7hgRe8Vw0an2Zwe4gyGVbDiDg8znE0xmlBkbjpky
        EpizCq51KRFClJB7vpqY2ov3nrS79aw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1636552702;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sXZTBdeyVQwbfHLEl2Qd3oJBHCIZMitnb/RbNeAIjJY=;
        b=sbsvONG8khFAQhe3w0KvitiT8akzWBEgU11b//FXCollxDs6K30cPetcf4Rxt1r5bwgy7S
        C4cP68rZQR+42TBw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id EC40F13BFF;
        Wed, 10 Nov 2021 13:58:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id CzYjNv3Pi2HCLgAAMHmgww
        (envelope-from <dkirjanov@suse.de>); Wed, 10 Nov 2021 13:58:21 +0000
Subject: Re: [PATCH v4] Add payload to be 32-bit aligned to fix dropped
 packets
To:     Kumar Thangavel <kumarthangavel.hcl@gmail.com>,
        Samuel Mendoza-Jonas <sam@mendozajonas.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     openbmc@lists.ozlabs.org, linux-aspeed@lists.ozlabs.org,
        patrickw3@fb.com, Amithash Prasad <amithash@fb.com>,
        velumanit@hcl.com, sdasari@fb.com, netdev@vger.kernel.org
References: <20211110095432.GA9571@gmail.com>
From:   Denis Kirjanov <dkirjanov@suse.de>
Message-ID: <3f23e37d-98fd-26db-6851-73a63c4f6d0a@suse.de>
Date:   Wed, 10 Nov 2021 16:58:21 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211110095432.GA9571@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: ru
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



11/10/21 12:54 PM, Kumar Thangavel пишет:
> Update NC-SI command handler (both standard and OEM) to take into
> account of payload paddings in allocating skb (in case of payload
> size is not 32-bit aligned).
> 
> The checksum field follows payload field, without taking payload
> padding into account can cause checksum being truncated, leading to
> dropped packets.

Please add Fixes tag
> 
> Signed-off-by: Kumar Thangavel <thangavel.k@hcl.com>
> Acked-by: Samuel Mendoza-Jonas <sam@mendozajonas.com>
> Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
> 
> ---
>    v4:
>     - Updated existing macro for max function
> 
>    v3:
>     - Added Macro for MAX
>     - Fixed the missed semicolon
> 
>    v2:
>     - Added NC-SI spec version and section
>     - Removed blank line
>     - corrected spellings
> 
>    v1:
>     - Initial draft
> 
> ---
> ---
>   net/ncsi/ncsi-cmd.c | 21 +++++++++++++--------
>   1 file changed, 13 insertions(+), 8 deletions(-)
> 
> diff --git a/net/ncsi/ncsi-cmd.c b/net/ncsi/ncsi-cmd.c
> index ba9ae482141b..e44fe138c20f 100644
> --- a/net/ncsi/ncsi-cmd.c
> +++ b/net/ncsi/ncsi-cmd.c
> @@ -213,12 +213,16 @@ static int ncsi_cmd_handler_oem(struct sk_buff *skb,
>   {
>   	struct ncsi_cmd_oem_pkt *cmd;
>   	unsigned int len;
> +	/* NC-SI spec DSP_0222_1.2.0, section 8.2.2.2
> +	 * requires payload to be padded with 0 to
> +	 * 32-bit boundary before the checksum field.
> +	 * Ensure the padding bytes are accounted for in
> +	 * skb allocation
> +	 */
>   
> +	unsigned short payload = ALIGN(nca->payload, 4);
>   	len = sizeof(struct ncsi_cmd_pkt_hdr) + 4;
> -	if (nca->payload < 26)
> -		len += 26;
Would be nice to have a constant
> -	else
> -		len += nca->payload;
> +	len += max(payload, 26);
>   
>   	cmd = skb_put_zero(skb, len);
>   	memcpy(&cmd->mfr_id, nca->data, nca->payload);
> @@ -272,6 +276,7 @@ static struct ncsi_request *ncsi_alloc_command(struct ncsi_cmd_arg *nca)
>   	struct net_device *dev = nd->dev;
>   	int hlen = LL_RESERVED_SPACE(dev);
>   	int tlen = dev->needed_tailroom;
> +	int payload;
>   	int len = hlen + tlen;
>   	struct sk_buff *skb;
>   	struct ncsi_request *nr;
> @@ -281,14 +286,14 @@ static struct ncsi_request *ncsi_alloc_command(struct ncsi_cmd_arg *nca)
>   		return NULL;
>   
>   	/* NCSI command packet has 16-bytes header, payload, 4 bytes checksum.
> +	 * Payload needs padding so that the checksum field following payload is
> +	 * aligned to 32-bit boundary.
>   	 * The packet needs padding if its payload is less than 26 bytes to
>   	 * meet 64 bytes minimal ethernet frame length.
>   	 */
>   	len += sizeof(struct ncsi_cmd_pkt_hdr) + 4;
> -	if (nca->payload < 26)
> -		len += 26;
> -	else
> -		len += nca->payload;
> +	payload = ALIGN(nca->payload, 4);
> +	len += max(payload, 26);
>   
>   	/* Allocate skb */
>   	skb = alloc_skb(len, GFP_ATOMIC);
> 
