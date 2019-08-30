Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9347FA3FCD
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 23:44:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728350AbfH3Vo2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 17:44:28 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:37836 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728324AbfH3Vo1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Aug 2019 17:44:27 -0400
Received: by mail-pl1-f193.google.com with SMTP id bj8so3941407plb.4
        for <netdev@vger.kernel.org>; Fri, 30 Aug 2019 14:44:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=giW74FqPVQw39MCuJlqnNavIVVkrnnPUjz7uKsnAFBE=;
        b=V7KMsgfTD6HjIIRshuX9MFa2+uIHfQLdoaoR1Zd/vzxy1HgquDnvEOrUt6TLb/8XJF
         n25/rcTdICRw8VoIyf58cC8MFUDwJEnx9mDUYU41G50U4mNY487sKG4kxp0yVw2ae81H
         S8rX1jmYEnNgES0uhwTehUjUNSIPBjMlclN2+E9YNca7BtSXRpMs7SO0W+qf9msHVOBF
         IRkSYdy/W74d9DiRHrtT9PDL8T19/9FAvihIHtXWVs6/+VK1qopcGa7ynq08R4lnIMGo
         UD3eMSUB1Y8wNz2buvYMvcJDrmaCaKIpVi8rlWk2L4d3clEiwJD/ZIzdAdARuIxkJi2l
         fk2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=giW74FqPVQw39MCuJlqnNavIVVkrnnPUjz7uKsnAFBE=;
        b=ecsvv8vxkq/KVmSe4Nvvym/PaUP4LaqJpMRJ1XdGC2E/Jivr1QP5IJ/eN3pAFFeqIC
         cTsVtYYEYaEEQENqj2pBUi1CPoN9ZXjYWGjndmJ0D/PMQpw2bbLpqm79/ut9oOPkqWkf
         YxA+N2hDEjXwlGpQDIJEoD9P0DTZqHr2A4eOuXqiKbhaN8u2Idg0d6f7Hvd5OtvAUtla
         VmPa0Sow5Sc8eRvavKr/KjuifSQeKBZjOD09AUOMyy4tRueYbiE0q55C9p924VX9472a
         Y/UGNsRrMCkZQg5x7QHcHi+/nEdS1UPwF92lyqJBxz49KAJYn9ngMgr6j03ezFdKeZpX
         aowg==
X-Gm-Message-State: APjAAAUFizoOojXYyUyqBfqU6luSvfzFb1SxyMudLaBOXRNSg8DTkHyP
        QIXCZLA+MsvX9685haTqhQ+ggg==
X-Google-Smtp-Source: APXvYqxH218g8TrSknWgNeFw1g5I4r1mi6hy7zn+ISxYPNISR9j0hmWlFAE7jeKFreGFMWH4t16i5A==
X-Received: by 2002:a17:902:8301:: with SMTP id bd1mr16433966plb.120.1567201467005;
        Fri, 30 Aug 2019 14:44:27 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id k64sm6010144pgk.74.2019.08.30.14.44.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 30 Aug 2019 14:44:26 -0700 (PDT)
Subject: Re: [PATCH v6 net-next 15/19] ionic: Add Tx and Rx handling
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
References: <20190829182720.68419-1-snelson@pensando.io>
 <20190829182720.68419-16-snelson@pensando.io>
 <20190829163319.0f4e8707@cakuba.netronome.com>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <31ea9c22-15e0-86db-a92d-76cee56fc738@pensando.io>
Date:   Fri, 30 Aug 2019 14:44:24 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190829163319.0f4e8707@cakuba.netronome.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/29/19 4:33 PM, Jakub Kicinski wrote:
> On Thu, 29 Aug 2019 11:27:16 -0700, Shannon Nelson wrote:
>> +static int ionic_tx_tso(struct ionic_queue *q, struct sk_buff *skb)
>> +{
>> +	struct ionic_tx_stats *stats = q_to_tx_stats(q);
>> +	struct ionic_desc_info *abort = q->head;
>> +	struct device *dev = q->lif->ionic->dev;
>> +	struct ionic_desc_info *rewind = abort;
>> +	struct ionic_txq_sg_elem *elem;
>> +	struct ionic_txq_desc *desc;
>> +	unsigned int frag_left = 0;
>> +	unsigned int offset = 0;
>> +	unsigned int len_left;
>> +	dma_addr_t desc_addr;
>> +	unsigned int hdrlen;
>> +	unsigned int nfrags;
>> +	unsigned int seglen;
>> +	u64 total_bytes = 0;
>> +	u64 total_pkts = 0;
>> +	unsigned int left;
>> +	unsigned int len;
>> +	unsigned int mss;
>> +	skb_frag_t *frag;
>> +	bool start, done;
>> +	bool outer_csum;
>> +	bool has_vlan;
>> +	u16 desc_len;
>> +	u8 desc_nsge;
>> +	u16 vlan_tci;
>> +	bool encap;
>> +	int err;
>> +
>> +	mss = skb_shinfo(skb)->gso_size;
>> +	nfrags = skb_shinfo(skb)->nr_frags;
>> +	len_left = skb->len - skb_headlen(skb);
>> +	outer_csum = (skb_shinfo(skb)->gso_type & SKB_GSO_GRE_CSUM) ||
>> +		     (skb_shinfo(skb)->gso_type & SKB_GSO_UDP_TUNNEL_CSUM);
>> +	has_vlan = !!skb_vlan_tag_present(skb);
>> +	vlan_tci = skb_vlan_tag_get(skb);
>> +	encap = skb->encapsulation;
>> +
>> +	/* Preload inner-most TCP csum field with IP pseudo hdr
>> +	 * calculated with IP length set to zero.  HW will later
>> +	 * add in length to each TCP segment resulting from the TSO.
>> +	 */
>> +
>> +	if (encap)
>> +		err = ionic_tx_tcp_inner_pseudo_csum(skb);
>> +	else
>> +		err = ionic_tx_tcp_pseudo_csum(skb);
>> +	if (err)
>> +		return err;
>> +
>> +	if (encap)
>> +		hdrlen = skb_inner_transport_header(skb) - skb->data +
>> +			 inner_tcp_hdrlen(skb);
>> +	else
>> +		hdrlen = skb_transport_offset(skb) + tcp_hdrlen(skb);
>> +
>> +	seglen = hdrlen + mss;
>> +	left = skb_headlen(skb);
>> +
>> +	desc = ionic_tx_tso_next(q, &elem);
>> +	start = true;
>> +
>> +	/* Chop skb->data up into desc segments */
>> +
>> +	while (left > 0) {
>> +		len = min(seglen, left);
>> +		frag_left = seglen - len;
>> +		desc_addr = ionic_tx_map_single(q, skb->data + offset, len);
>> +		if (dma_mapping_error(dev, desc_addr))
>> +			goto err_out_abort;
>> +		desc_len = len;
>> +		desc_nsge = 0;
>> +		left -= len;
>> +		offset += len;
>> +		if (nfrags > 0 && frag_left > 0)
>> +			continue;
>> +		done = (nfrags == 0 && left == 0);
>> +		ionic_tx_tso_post(q, desc, skb,
>> +				  desc_addr, desc_nsge, desc_len,
>> +				  hdrlen, mss,
>> +				  outer_csum,
>> +				  vlan_tci, has_vlan,
>> +				  start, done);
>> +		total_pkts++;
>> +		total_bytes += start ? len : len + hdrlen;
>> +		desc = ionic_tx_tso_next(q, &elem);
>> +		start = false;
>> +		seglen = mss;
>> +	}
>> +
>> +	/* Chop skb frags into desc segments */
>> +
>> +	for (frag = skb_shinfo(skb)->frags; len_left; frag++) {
>> +		offset = 0;
>> +		left = skb_frag_size(frag);
>> +		len_left -= left;
>> +		nfrags--;
>> +		stats->frags++;
>> +
>> +		while (left > 0) {
>> +			if (frag_left > 0) {
>> +				len = min(frag_left, left);
>> +				frag_left -= len;
>> +				elem->addr =
>> +				    cpu_to_le64(ionic_tx_map_frag(q, frag,
>> +								  offset, len));
>> +				if (dma_mapping_error(dev, elem->addr))
>> +					goto err_out_abort;
>> +				elem->len = cpu_to_le16(len);
>> +				elem++;
>> +				desc_nsge++;
>> +				left -= len;
>> +				offset += len;
>> +				if (nfrags > 0 && frag_left > 0)
>> +					continue;
>> +				done = (nfrags == 0 && left == 0);
>> +				ionic_tx_tso_post(q, desc, skb, desc_addr,
>> +						  desc_nsge, desc_len,
>> +						  hdrlen, mss, outer_csum,
>> +						  vlan_tci, has_vlan,
>> +						  start, done);
>> +				total_pkts++;
>> +				total_bytes += start ? len : len + hdrlen;
>> +				desc = ionic_tx_tso_next(q, &elem);
>> +				start = false;
>> +			} else {
>> +				len = min(mss, left);
>> +				frag_left = mss - len;
>> +				desc_addr = ionic_tx_map_frag(q, frag,
>> +							      offset, len);
>> +				if (dma_mapping_error(dev, desc_addr))
>> +					goto err_out_abort;
>> +				desc_len = len;
>> +				desc_nsge = 0;
>> +				left -= len;
>> +				offset += len;
>> +				if (nfrags > 0 && frag_left > 0)
>> +					continue;
>> +				done = (nfrags == 0 && left == 0);
>> +				ionic_tx_tso_post(q, desc, skb, desc_addr,
>> +						  desc_nsge, desc_len,
>> +						  hdrlen, mss, outer_csum,
>> +						  vlan_tci, has_vlan,
>> +						  start, done);
>> +				total_pkts++;
>> +				total_bytes += start ? len : len + hdrlen;
>> +				desc = ionic_tx_tso_next(q, &elem);
>> +				start = false;
>> +			}
>> +		}
>> +	}
>> +
>> +	stats->pkts += total_pkts;
>> +	stats->bytes += total_bytes;
>> +	stats->tso++;
>> +
>> +	return 0;
>> +
>> +err_out_abort:
>> +	while (rewind->desc != q->head->desc) {
>> +		ionic_tx_clean(q, rewind, NULL, NULL);
>> +		rewind = rewind->next;
>> +	}
>> +	q->head = abort;
>> +
>> +	return -ENOMEM;
>> +}
> There's definitely a function for helping drivers which can't do full
> TSO slice up the packet, but I can't find it now 😫😫
>
> Eric would definitely know.
>
> Did you have a look? Would it be useful here?

Yes, obviously this could use some work for clarity and supportability, 
and I think for performance as well.  But since it works, I've been 
concentrating on getting other parts of the driver working before coming 
back to this.  If there are some tools that can help clean this up, I 
would be interested to see them.

sln



