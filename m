Return-Path: <netdev+bounces-12063-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EA45A735DA4
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 21:00:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9965E280FE1
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 19:00:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD5BD14261;
	Mon, 19 Jun 2023 19:00:33 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAC1C12B70
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 19:00:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2EEFC433C0;
	Mon, 19 Jun 2023 19:00:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1687201227;
	bh=HhrM33/jH6zIhsQ4kVODLNRvaiLMFm/8HFU2b668FnE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=UltQtbTKv5OstUSptV/pRgsebz2em87ZtoI+LVUQai9b3yqh8qJ/agq57AYvfAh5t
	 uk/g6giZPIlao46sJI2k/+L1kfuCvBgLH0rMoW1mNuyk8wOFbxedmNXOfdgjTnIqNO
	 N8EKWTJjpCvoMjZzLPJKgUJ/cr1t9Jpw+bnZTxcyIc6ZCt5wQlOyDwi7NdgqHmFUNW
	 pySQK7khzAikZS3Ex9WNwXCPq9lMyGv1TLRzvfaShsrgRbF1m31avdRveUFPa8aNoF
	 oa4pOb2mZpzYhBghC/0c6NCDrmb54yV5EHWXK19w6AmyTUdW5vsJinr1KVjBEdtwcE
	 cBmvlzPWSkjXg==
Date: Mon, 19 Jun 2023 12:00:25 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Donald Hunter <donald.hunter@gmail.com>
Cc: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, Eric
 Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
 donald.hunter@redhat.com
Subject: Re: [RFC net-next v1] tools: ynl: Add an strace rendering mode to
 ynl-gen
Message-ID: <20230619120025.74c33a5d@kernel.org>
In-Reply-To: <m2v8fjahus.fsf@gmail.com>
References: <20230615151336.77589-1-donald.hunter@gmail.com>
	<20230615200036.393179ae@kernel.org>
	<m2o7lfhft6.fsf@gmail.com>
	<20230616111129.311dfd2d@kernel.org>
	<m2v8fjahus.fsf@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 19 Jun 2023 11:04:11 +0100 Donald Hunter wrote:
> I tried these suggestions out and they seem a bit problematic. For
> struct references I don't see a way to validate them, when it's not C
> codegen. Non C consumers will need to enumarete the struct references
> they 'understand'. The printk formats are meaningful in kernel, but not
> directly usable elsewhere, without writing a parser for them.
> 
> It seems desirable to have schema validation for the values and I tried
> using the %p printk formats as the enumeration. Using this format, the
> values need to be quoted everywhere. See diff below.
> 
> The printk formats also carry specific opinions about formatting details
> such as the case and separator to be used for output. This seems
> orthogonal to a type annotation about meaning.
> 
> Perhaps the middle ground is to derive a list of format specificer
> enumerations from the printk formats, but that's maybe not much
> different from defining our own?

Fair point. Our own names would be easier to understand -- OTOH I like
how the print formats almost forcefully drive the point that these are
supposed to be used exclusively for printing. 

If someone needs to interpret the data they should add a struct.

But I guess a big fat warning above the documentation and calling the
attribute "print-format" / "print-hint" could work as well? Up to you.

Hope this makes sense.

> I currently have "%pI4", "%pI6", "%pM", "%pMF", "%pU", "%ph", which
> could be represented as ipv4, ipv6, mac, fddi, uuid, hex. From the
> printk formats documentation, the only other one I can see is bluetooth.
> The other formats all look like they cover composite values.

> diff --git a/Documentation/netlink/genetlink-legacy.yaml b/Documentation/netlink/genetlink-legacy.yaml
> index b474889b49ff..f3ecdeb7c38c 100644
> --- a/Documentation/netlink/genetlink-legacy.yaml
> +++ b/Documentation/netlink/genetlink-legacy.yaml

If we're only talking about printing we will want to extend the support
to new families as well.

