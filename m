Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99F5E397A76
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 21:09:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234765AbhFATKr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 15:10:47 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:54498 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234650AbhFATKp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Jun 2021 15:10:45 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1622574543; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=+bLsBPHU1LaIdCv04nFKLHzd65rHOKclCOVC2UEdtNU=;
 b=f5M8NMMCZ9jtZh/UEf1Q+1HGrdx+s9d9bwhBRyh0Ezeo1PFY7Gk4bPRN1eDWR2Kf0LDWSVYn
 uNpmfpjKyO5IUnTwqoNdNYed0fpneN8gYeuuA3aHAtilnchH8WtA2U2hEA5U1tIeIrtnw9WR
 jsKDtzSh023g+VrWxGi320nx3zw=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-west-2.postgun.com with SMTP id
 60b685c281efe91cdafdcc2a (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 01 Jun 2021 19:08:50
 GMT
Sender: sharathv=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 4D6A5C4338A; Tue,  1 Jun 2021 19:08:50 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: sharathv)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 8D5D2C433D3;
        Tue,  1 Jun 2021 19:08:49 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 02 Jun 2021 00:38:49 +0530
From:   sharathv@codeaurora.org
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, elder@kernel.org, cpratapa@codeaurora.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v7 3/3] net: ethernet: rmnet: Add support for
 MAPv5 egress packets
In-Reply-To: <20210528161131.5f7b9920@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
References: <1622105322-2975-1-git-send-email-sharathv@codeaurora.org>
 <1622105322-2975-4-git-send-email-sharathv@codeaurora.org>
 <20210528161131.5f7b9920@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Message-ID: <bea88cea5094f7fec640a5d867b5a31a@codeaurora.org>
X-Sender: sharathv@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-05-29 04:41, Jakub Kicinski wrote:
> On Thu, 27 May 2021 14:18:42 +0530 Sharath Chandra Vurukala wrote:
>> Adding support for MAPv5 egress packets.
>> 
>> This involves adding the MAPv5 header and setting the 
>> csum_valid_required
>> in the checksum header to request HW compute the checksum.
>> 
>> Corresponding stats are incremented based on whether the checksum is
>> computed in software or HW.
>> 
>> New stat has been added which represents the count of packets whose
>> checksum is calculated by the HW.
>> 
>> Signed-off-by: Sharath Chandra Vurukala <sharathv@codeaurora.org>
> 
>> +static void rmnet_map_v5_checksum_uplink_packet(struct sk_buff *skb,
>> +						struct rmnet_port *port,
>> +						struct net_device *orig_dev)
>> +{
>> +	struct rmnet_priv *priv = netdev_priv(orig_dev);
>> +	struct rmnet_map_v5_csum_header *ul_header;
>> +
>> +	if (!(port->data_format & RMNET_FLAGS_EGRESS_MAP_CKSUMV5))
>> +		return;
> 
> how can we get here if this condition is not met? Looks like defensive
> programming.
> 

Yes we get here only for the MAPv5 case, as you think this is just a 
defensive code.
will remove this in next patch.

>> +	ul_header = skb_push(skb, sizeof(*ul_header));
> 
> Are you making sure you can modify head? I only see a check if there is
> enough headroom but not if head is writable (skb_cow_head()).
> 

TSkb_cow_head() changes will be done in the rmnet_map_egress_handler() 
in the next patch.

>> +	memset(ul_header, 0, sizeof(*ul_header));
>> +	ul_header->header_info = 
>> u8_encode_bits(RMNET_MAP_HEADER_TYPE_CSUM_OFFLOAD,
>> +						MAPV5_HDRINFO_HDR_TYPE_FMASK);
> 
> Is prepending the header required even when packet doesn't need
> checksuming?
> 
>> +	if (skb->ip_summed == CHECKSUM_PARTIAL) {
>> +		void *iph = (char *)ul_header + sizeof(*ul_header);
> 
> ip_hdr(skb)
> 

>> +		__sum16 *check;
>> +		void *trans;
>> +		u8 proto;
>> +
>> +		if (skb->protocol == htons(ETH_P_IP)) {
>> +			u16 ip_len = ((struct iphdr *)iph)->ihl * 4;
>> +
>> +			proto = ((struct iphdr *)iph)->protocol;
>> +			trans = iph + ip_len;
>> +		} else if (skb->protocol == htons(ETH_P_IPV6)) {
>> +#if IS_ENABLED(CONFIG_IPV6)
>> +			u16 ip_len = sizeof(struct ipv6hdr);
>> +
>> +			proto = ((struct ipv6hdr *)iph)->nexthdr;
>> +			trans = iph + ip_len;
>> +#else
>> +			priv->stats.csum_err_invalid_ip_version++;
>> +			goto sw_csum;
>> +#endif /* CONFIG_IPV6 */
>> +		} else {
>> +			priv->stats.csum_err_invalid_ip_version++;
>> +			goto sw_csum;
>> +		}
>> +
>> +		check = rmnet_map_get_csum_field(proto, trans);
>> +		if (check) {
>> +			skb->ip_summed = CHECKSUM_NONE;
>> +			/* Ask for checksum offloading */
>> +			ul_header->csum_info |= MAPV5_CSUMINFO_VALID_FLAG;
>> +			priv->stats.csum_hw++;
>> +			return;
> 
> Please try to keep the success path unindented.
> 

Sure will take care of these comments in next patch.
>> +		}
>> +	}
>> +
>> +sw_csum:
>> +	priv->stats.csum_sw++;
>> +}
