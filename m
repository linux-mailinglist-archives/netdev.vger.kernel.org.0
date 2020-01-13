Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1351D138D9F
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 10:21:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728558AbgAMJVf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 04:21:35 -0500
Received: from fd.dlink.ru ([178.170.168.18]:50534 "EHLO fd.dlink.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725978AbgAMJVc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Jan 2020 04:21:32 -0500
Received: by fd.dlink.ru (Postfix, from userid 5000)
        id C45651B21576; Mon, 13 Jan 2020 12:21:27 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 fd.dlink.ru C45651B21576
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dlink.ru; s=mail;
        t=1578907287; bh=awOlvhtlkFxUadttzRRBmg6cBvcEOkaMn5I2RIuDKkk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References;
        b=BhC9j6l0IwSouM7LnOZlNxVvH0HFaP76STmf6vmWG6UWjJLt1/xg4JMW5JxlnIPkf
         5+riVBws3ayChuXWPRhmlESsvxxVYUp8sPt1gsj5BXzdmU1F/QXgNmVNXUupfc/NR/
         yhZwDrd4EG14tZ5fPSU3VciNc9am5I22yhN7LfIc=
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.dlink.ru
X-Spam-Level: 
X-Spam-Status: No, score=-99.2 required=7.5 tests=BAYES_50,URIBL_BLOCKED,
        USER_IN_WHITELIST autolearn=disabled version=3.4.2
Received: from mail.rzn.dlink.ru (mail.rzn.dlink.ru [178.170.168.13])
        by fd.dlink.ru (Postfix) with ESMTP id B0E611B201E9;
        Mon, 13 Jan 2020 12:21:14 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 fd.dlink.ru B0E611B201E9
Received: from mail.rzn.dlink.ru (localhost [127.0.0.1])
        by mail.rzn.dlink.ru (Postfix) with ESMTP id E6CE71B2613D;
        Mon, 13 Jan 2020 12:21:13 +0300 (MSK)
Received: from mail.rzn.dlink.ru (localhost [127.0.0.1])
        by mail.rzn.dlink.ru (Postfix) with ESMTPA;
        Mon, 13 Jan 2020 12:21:13 +0300 (MSK)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Mon, 13 Jan 2020 12:21:13 +0300
From:   Alexander Lobakin <alobakin@dlink.ru>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Edward Cree <ecree@solarflare.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Sean Wang <sean.wang@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Taehee Yoo <ap420073@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Stanislav Fomichev <sdf@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Song Liu <songliubraving@fb.com>,
        Matteo Croce <mcroce@redhat.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Paul Blakey <paulb@mellanox.com>,
        Yoshiki Komachi <komachi.yoshiki@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH RFC net-next 05/19] net: dsa: tag_ar9331: add GRO
 callbacks
In-Reply-To: <ee6f83fd-edf4-5a98-9868-4cbe9e226b9b@gmail.com>
References: <20191230143028.27313-1-alobakin@dlink.ru>
 <20191230143028.27313-6-alobakin@dlink.ru>
 <ee6f83fd-edf4-5a98-9868-4cbe9e226b9b@gmail.com>
User-Agent: Roundcube Webmail/1.4.0
Message-ID: <ed0ad0246c95a9ee87352d8ddbf0d4a1@dlink.ru>
X-Sender: alobakin@dlink.ru
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Florian Fainelli wrote 30.12.2019 21:20:
> On 12/30/19 6:30 AM, Alexander Lobakin wrote:
>> Add GRO callbacks to the AR9331 tagger so GRO layer can now process
>> such frames.
>> 
>> Signed-off-by: Alexander Lobakin <alobakin@dlink.ru>
> 
> This is a good example and we should probably build a tagger 
> abstraction
> that is much simpler to fill in callbacks for (although indirect
> function calls may end-up killing performance with retpoline and
> friends), but let's consider this idea.

Hey al,
Sorry for late replies, was in a big trip.

The performance issue was the main reason why I chose to write full
.gro_receive() for every single tagger instead of providing a bunch
of abstraction callbacks. It really isn't a problem for MIPS, on
which I'm working on this stuff, but can kill any advantages that we
could get from GRO support on e.g. x86.

>> ---
>>  net/dsa/tag_ar9331.c | 77 
>> ++++++++++++++++++++++++++++++++++++++++++++
>>  1 file changed, 77 insertions(+)
>> 
>> diff --git a/net/dsa/tag_ar9331.c b/net/dsa/tag_ar9331.c
>> index c22c1b515e02..99cc7fd92d8e 100644
>> --- a/net/dsa/tag_ar9331.c
>> +++ b/net/dsa/tag_ar9331.c
>> @@ -100,12 +100,89 @@ static void ar9331_tag_flow_dissect(const struct 
>> sk_buff *skb, __be16 *proto,
>>  	*proto = ar9331_tag_encap_proto(skb->data);
>>  }
>> 
>> +static struct sk_buff *ar9331_tag_gro_receive(struct list_head *head,
>> +					      struct sk_buff *skb)
>> +{
>> +	const struct packet_offload *ptype;
>> +	struct sk_buff *p, *pp = NULL;
>> +	u32 data_off, data_end;
>> +	const u8 *data;
>> +	int flush = 1;
>> +
>> +	data_off = skb_gro_offset(skb);
>> +	data_end = data_off + AR9331_HDR_LEN;
> 
> AR9331_HDR_LEN is a parameter here which is incidentally
> dsa_device_ops::overhead.

Or we can split .overhead to .rx_len and .tx_len and use the first
to help GRO layer and flow dissector and the second to determine
total overhead to correct MTU value. Smth like:

mtu = max(tag_ops->rx_len, tag_ops->tx_len);

>> +
>> +	data = skb_gro_header_fast(skb, data_off);
>> +	if (skb_gro_header_hard(skb, data_end)) {
>> +		data = skb_gro_header_slow(skb, data_end, data_off);
>> +		if (unlikely(!data))
>> +			goto out;
>> +	}
>> +
>> +	/* Data that is to the left from the current position is already
>> +	 * pulled to the head
>> +	 */
>> +	if (unlikely(!ar9331_tag_sanity_check(skb->data + data_off)))
>> +		goto out;
> 
> This is applicable to all taggers, they need to verify the sanity of 
> the
> header they are being handed.
> 
>> +
>> +	rcu_read_lock();
>> +
>> +	ptype = gro_find_receive_by_type(ar9331_tag_encap_proto(data));
> 
> If there is no encapsulation a tagger can return the frame's protocol
> directly, so similarly the tagger can be interrogated for returning 
> that.
> 
>> +	if (!ptype)
>> +		goto out_unlock;
>> +
>> +	flush = 0;
>> +
>> +	list_for_each_entry(p, head, list) {
>> +		if (!NAPI_GRO_CB(p)->same_flow)
>> +			continue;
>> +
>> +		if (ar9331_tag_source_port(skb->data + data_off) ^
>> +		    ar9331_tag_source_port(p->data + data_off))
> 
> Similarly here, the tagger could provide a function whose job is to
> return the port number from within its own tag.
> 
> So with that being said, what do you think about building a tagger
> abstraction which is comprised of:
> 
> - header length which is dsa_device_ops::overhead
> - validate_tag()
> - get_tag_encap_proto()
> - get_port_number()
> 
> and the rest is just wrapping the general GRO list manipulation?

get_tag_encap_proto() and get_port_number() would be called more
than once in that case for every single frame. Not sure if it is
a good idea regarding to mentioned retpoline issues.

> Also, I am wondering should we somehow expose the DSA master
> net_device's napi_struct such that we could have the DSA slave
> net_devices call napi_gro_receive() themselves directly such that they
> could also perform additional GRO on top of Ethernet frames?

There's no reason to pass frames to GRO layer more than once.

The most correct way to handle frames is to pass them to networking
stack only after DSA tag extraction and removal. That's kinda how
mac80211 infra works. But this is rather problematic for DSA as it
keeps Ethernet controller drivers and taggers completely independent
from each others.

I also had an idea to use net_device::rx_handler for tag processing
instead of dsa_pack_type. CPU ports can't be bridged anyway, so this
should not be a problem an the first look.

Regards,
ᚷ ᛖ ᚢ ᚦ ᚠ ᚱ
