Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D19721CFC5
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 08:35:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728672AbgGMGfq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 02:35:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726360AbgGMGfp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 02:35:45 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3D51C061794;
        Sun, 12 Jul 2020 23:35:45 -0700 (PDT)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1594622144;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lGwmJIkZOZkMHJGtImhb5KqsxN75lLuiXne9IMeGa/A=;
        b=oOiV1kScW2I2fOrQI2UkUlnU9FL+ia6y5UCOhe9XKKToyeXoMs7riH3eSbnViK5X/UVodR
        skTyg0yc7dKwfKEGKZeNW4NG8hoYjoC2bEnRsUUZuDMmA7i6FT81rbeG+F2J+WSFwdqDhk
        G9Cxv5Jo53WG4gTIW+TDYWLzcAfn5qqg8oGonbIhSN4VCDmDLwE8cxRfnIGNohqqFzU21G
        YBsS0BgDDX5im9WOrN8zu3+FGSjZ5SgYySHNp7IRfL3xSdTEPnV0uTt6hsajMGaa0RnOBt
        2JsmVjrcDV3IByF2wRI4rWlWkyZX20//OXjXUckptY6n7YvtrENR0+ZfqaOqYQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1594622144;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lGwmJIkZOZkMHJGtImhb5KqsxN75lLuiXne9IMeGa/A=;
        b=E1asMlFW5LrXUA2VCU8sD4kjaSOZE8GaMxZVbCXjklrYTfzdiQ6rfV/9GwcUm3+WUQLZmW
        IVX+ciVo5bYGHxDw==
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>,
        ilias.apalodimas@linaro.org, Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH v1 4/8] net: dsa: hellcreek: Add support for hardware timestamping
In-Reply-To: <20200711203810.GB27467@hoboy>
References: <20200710113611.3398-1-kurt@linutronix.de> <20200710113611.3398-5-kurt@linutronix.de> <20200711203810.GB27467@hoboy>
Date:   Mon, 13 Jul 2020 08:35:43 +0200
Message-ID: <87pn8zncqo.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain

On Sat Jul 11 2020, Richard Cochran wrote:
> On Fri, Jul 10, 2020 at 01:36:07PM +0200, Kurt Kanzenbach wrote:
>> +static void hellcreek_get_rxts(struct hellcreek *hellcreek,
>> +			       struct hellcreek_port_hwtstamp *ps,
>> +			       struct sk_buff *skb, struct sk_buff_head *rxq,
>> +			       int port)
>> +{
>> +	struct skb_shared_hwtstamps *shwt;
>> +	struct sk_buff_head received;
>> +	unsigned long flags;
>> +
>> +	/* The latched timestamp belongs to one of the received frames. */
>> +	__skb_queue_head_init(&received);
>> +
>> +	/* Lock & disable interrupts */
>> +	spin_lock_irqsave(&rxq->lock, flags);
>> +
>> +	/* Add the reception queue "rxq" to the "received" queue an reintialize
>> +	 * "rxq".  From now on, we deal with "received" not with "rxq"
>> +	 */
>> +	skb_queue_splice_tail_init(rxq, &received);
>> +
>> +	spin_unlock_irqrestore(&rxq->lock, flags);
>> +
>> +	for (; skb; skb = __skb_dequeue(&received)) {
>> +		unsigned int type;
>> +		u8 *hdr;
>> +		u64 ns;
>> +
>> +		/* Get nanoseconds from ptp packet */
>> +		type = SKB_PTP_TYPE(skb);
>> +		hdr  = parse_ptp_header(skb, type);
>> +		ns   = hellcreek_get_reserved_field(hdr);
>
> You might consider clearing the reserved field at this point.  Some
> user space SW might consider non-zero reserved fields as corrupt!

Indeed. Never thought about it.

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAl8MAL8ACgkQeSpbgcuY
8KY1TA/+KEdPEl04h/iBlEc7pnDGDE0KAnasnn5FoDOCaQdNiK5lUyvV3F0aG6JT
4Y4K8bjNiFVoWczws2xJ7G/fdLL/EoSURiHUaq6tY5ciCRBUbG51H4Q6nBBPY8nR
CZqQMcBrki3/fWNB0XICv+iXyvmUEQ6wxBckHKU6cCmVxbiKKcD7m6gTVfrgJD26
261IlZuLxrn4CYtWD/pi897rMMO96SMKKWNuRLsDf0v86IOf8SFP1CTKAF2uGs1Y
k6HkoIK65F9EXEECk99tDoW/rzk1SqFEOzFHzVt/Qqa41Np87Jx/Z75O+9ge/qmj
IfsOUrgIOkOLiCfWr0poFGR6a5SUFi2m43IOQ8hndWbF08ySWdfXL94ChwUEZAXC
XIj9BSJdlZTYaEhygWlyrTWuOjDxDKM276W5PISVMIXfSr5Z02iYe7oAUY1SKagT
vMYzeZnTajzcc0JEVjzRdd5dzXrcvQ8ta3OaLtJUSByZ3S0GoFsmhE30gTrt31ye
fsi/RTk6/Nkzmt0nwQjBkWyeJLb0g2gs61viRo8e0K/siP3LrlZnj5eC3r0wybOQ
GFsJGyI9w3yx/DuXJMyfCu+2tixpvyIpKi+vGYOA7MXO68gUy11wxAtGx8EJyDIl
CJt7bj3msEzGQQ/z1p4pFNubCZIaNpV54KjK6sueKJ67zuQ5hOY=
=KSHc
-----END PGP SIGNATURE-----
--=-=-=--
