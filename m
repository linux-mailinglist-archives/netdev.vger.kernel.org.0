Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8870E10A3BE
	for <lists+netdev@lfdr.de>; Tue, 26 Nov 2019 19:00:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726019AbfKZSAJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Nov 2019 13:00:09 -0500
Received: from ssl.serverraum.org ([176.9.125.105]:40495 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725870AbfKZSAJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Nov 2019 13:00:09 -0500
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 8BCF323061;
        Tue, 26 Nov 2019 19:00:02 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1574791206;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=XFjsbWFmkqq9ohjy0WFJfEIgBf2ZR0PaOL39g84dy8k=;
        b=bPhFShXMrYu1xuaDyE5TkUZXxmv353oyHUGbc6nGzZyRb7IuR0s3r8FRxcAUQYSVXDHo/d
        AWxKzYvmWKWMaAslyhec5z0X5ZaZfV4xsgu1MSfKYwi2XReP6lI0k2hf7y2NVqNAIAb/hK
        pO0u0UAD5j7+xDLxX0zV8BhydOVcdUg=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 26 Nov 2019 19:00:02 +0100
From:   Michael Walle <michael@walle.cc>
To:     netdev@vger.kernel.org
Cc:     Richard Cochran <richardcochran@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: phy timestamping "library"
Message-ID: <a45cdb5be352ece0b724f7e03493c4ff@walle.cc>
X-Sender: michael@walle.cc
User-Agent: Roundcube Webmail/1.3.8
X-Spamd-Bar: /
X-Spam-Status: No, score=-0.10
X-Rspamd-Server: web
X-Spam-Score: -0.10
X-Rspamd-Queue-Id: 8BCF323061
X-Spamd-Result: default: False [-0.10 / 15.00];
         TO_DN_SOME(0.00)[];
         RCVD_COUNT_ZERO(0.00)[0];
         FROM_EQ_ENVFROM(0.00)[];
         MIME_TRACE(0.00)[0:+];
         MID_RHS_MATCH_FROM(0.00)[];
         ARC_NA(0.00)[];
         FROM_HAS_DN(0.00)[];
         RCPT_COUNT_THREE(0.00)[3];
         TO_MATCH_ENVRCPT_ALL(0.00)[];
         FREEMAIL_ENVRCPT(0.00)[gmail.com];
         MIME_GOOD(-0.10)[text/plain];
         DKIM_SIGNED(0.00)[];
         NEURAL_HAM(-0.00)[-0.774];
         FREEMAIL_CC(0.00)[gmail.com,lunn.ch]
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I'm working on PHY timestamping for the AR8031 PHY.

I try to factor out the timestamp handling of the dp83640 phy driver,
because my ar8031 phy driver uses almost the same logic. The dp83640 has
three lists, two skb queues for rx and tx and one lists to handle
out-of-order rx timestamps. The tx timestamps are handled in-order
because we already have the skbuf in the txqueue when a tx timestamp
arrives; I guess that is always true. The rx timestamps are allocated
from a pool and given back to it if there was a match between timestamp
and skb or if there was a timeout (just before passing the skb back to
the network stack).

So what I'd like to have in a seperate "library" is the following:
  - skb queues handling
  - rx timestamp pool handling
  - rx timestamp timeout handling
  - skb delivery to the network stack on either match or timeout

So what I'm looking to do is to have the following functions:

phyts_rx_skb(struct phyts *pt, struct sk_buff *skb);
phyts_tx_skb(struct phyts *pt, struct sk_buff *skb);
phyts_rx_timestamp(struct phyts *pt, struct phyts_ts *ts);
phyts_tx_timestamp(struct phyts *pt, struct phyts_ts *ts);
phyts_init(struct phyts *pt, <tbd>);

struct phyts {
	struct delayed_work ts_work;
	/* list of rx timestamps */
	struct list_head rxts;
	struct list_head rxpool;
	struct phyts_ts *rx_pool_data;
	/* protects above three fields from concurrent access */
	spinlock_t rx_lock;
	/* queues of incoming and outgoing packets */
	struct sk_buff_head rx_queue;
	struct sk_buff_head tx_queue;

	int (*match)(struct sk_buff *skb, struct phyts_ts *ts);
};

struct phyts_ts {
	struct list_head list;
	unsigned long tmo;
	ktime_t ts;
};

If the skb is accepted to be timestamped, the driver calls either
phyts_rx_skb() or phyts_tx_skb(). Once it received an timestamp, it
calls phyts_rx_timestamp() or phyts_tx_timestamp(). Everything else
would be handled by the lib.

Now I have the following problem: the original driver attaches more data
to the timestamp, as is my driver; this data is used by the match
function. Is there any pattern (1) where to allocate the memory for the
timestamp pool, (2) how to populate the pool and (3) how the driver can
request an element from the pool. I guess (1) has to be done in the
driver and I'd like to do (2) in the library.

So a driver part might look like:

struct rxts {
	struct phyts_ts phyts;
	u64 ns;
	u16 seqid;
	u8  msgtype;
	u16 hash;
};

The match function would get a pointer to this phyts element and can use
container_of() to cast the pointer back to its original "struct rxts".

To allocate the memory, the driver could do

   pool = kcalloc(num_rxts, sizeof(struct rxts), GFP_KERNEL);

But how can I give that memory to the lib in phyts_init() and how can
phyts_init() populate its rx_pool_data. Or maybe I'm getting it all
wrong and there is a better way ;)

Oh and the driver struct would look like:

struct dp83640_private {
	struct phyts pt;
..
};

And would then call phyts_init(&priv->pt) in its probe().

-michael
