Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88972A2AEE
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 01:33:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727041AbfH2Xdp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 19:33:45 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:44657 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725847AbfH2Xdp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 19:33:45 -0400
Received: by mail-ed1-f68.google.com with SMTP id a21so5871230edt.11
        for <netdev@vger.kernel.org>; Thu, 29 Aug 2019 16:33:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=xgPezxOShIBHuXUdkTwHJYHNzmYiQ1B0vkMUpjxZepA=;
        b=eGfrsqkEQAEIaOrHCpg+9bs7itdcaEVXHjWIWpAynr57C78JSW24Ta11lfyYe0U8/0
         Qs1qyGdtpbUKKi4U+l3HKYlspD5fpecl9lx4GvV0DtQ0fcH4iJIjTr6aXFVbBOQcUWBS
         Jiic7yreTplzQJaz/WlZe2JtoFDVM2uUivZx6t7GGaGsXlvVftyoqh0XTyGfuU6eMGs/
         r/I+Fmu3Tvz2mznYnA9RQuWaCF0//1PBxkR7mboVDEAPmeIj+5xP2IaqWGhg6LC9aAqA
         wilKt5hJDkul5L3cjvLrgw6s4LCcmwRyFsh9cF2aT9edZuAqmw+ItOeazL0mTIk73Y3r
         QDiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=xgPezxOShIBHuXUdkTwHJYHNzmYiQ1B0vkMUpjxZepA=;
        b=CFuBmntsk4AImSZeUaZOPTY18U5Xg3liSF6P9mx/Fgwt2nk6mHIBRtH8zK7vbQHFzN
         gQ5BK30CTcA7c6gFqB2K0zgp3wVr9YL7RxeMF1lY1inq/KZqxqAJfYiRnaUdGGyTF4Ua
         HgucrOcXNC1CuzJXvk27vitbp+v4ALG2DulfOt78xeCZ6nbJTjg9rcVpDzBrOnIuyTzM
         C7XCAUwXQWiSmJ1BQB3aoU0cxpZmPlavnd1dxL/AXrxLvvqiHSkFxuTH84TtmJsAr4Ki
         82pjOiFbCxhEMtGB6kVI0TAqISsw+8EMT7L050aJHAKdpltbl2D0R2DXt9IPolZZRYkv
         Fe9A==
X-Gm-Message-State: APjAAAX3px+0qin434YbYE8P3yh7E/CWk/QA6RA+5bJuHGaxM42sCWHz
        jRVt6tWj7Br94n2xbWy60uLRA9/Ug0Y=
X-Google-Smtp-Source: APXvYqwAmtvjP7o4wqos+ei4FhNipD8wQPidQUl6rOKW1VBMYUjQlAzGLDe3PUqpsLDqbxYNMMfJnQ==
X-Received: by 2002:aa7:d397:: with SMTP id x23mr12413407edq.11.1567121623387;
        Thu, 29 Aug 2019 16:33:43 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id f24sm688794edt.82.2019.08.29.16.33.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Aug 2019 16:33:43 -0700 (PDT)
Date:   Thu, 29 Aug 2019 16:33:19 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH v6 net-next 15/19] ionic: Add Tx and Rx handling
Message-ID: <20190829163319.0f4e8707@cakuba.netronome.com>
In-Reply-To: <20190829182720.68419-16-snelson@pensando.io>
References: <20190829182720.68419-1-snelson@pensando.io>
        <20190829182720.68419-16-snelson@pensando.io>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 29 Aug 2019 11:27:16 -0700, Shannon Nelson wrote:
> +static int ionic_tx_tso(struct ionic_queue *q, struct sk_buff *skb)
> +{
> +	struct ionic_tx_stats *stats =3D q_to_tx_stats(q);
> +	struct ionic_desc_info *abort =3D q->head;
> +	struct device *dev =3D q->lif->ionic->dev;
> +	struct ionic_desc_info *rewind =3D abort;
> +	struct ionic_txq_sg_elem *elem;
> +	struct ionic_txq_desc *desc;
> +	unsigned int frag_left =3D 0;
> +	unsigned int offset =3D 0;
> +	unsigned int len_left;
> +	dma_addr_t desc_addr;
> +	unsigned int hdrlen;
> +	unsigned int nfrags;
> +	unsigned int seglen;
> +	u64 total_bytes =3D 0;
> +	u64 total_pkts =3D 0;
> +	unsigned int left;
> +	unsigned int len;
> +	unsigned int mss;
> +	skb_frag_t *frag;
> +	bool start, done;
> +	bool outer_csum;
> +	bool has_vlan;
> +	u16 desc_len;
> +	u8 desc_nsge;
> +	u16 vlan_tci;
> +	bool encap;
> +	int err;
> +
> +	mss =3D skb_shinfo(skb)->gso_size;
> +	nfrags =3D skb_shinfo(skb)->nr_frags;
> +	len_left =3D skb->len - skb_headlen(skb);
> +	outer_csum =3D (skb_shinfo(skb)->gso_type & SKB_GSO_GRE_CSUM) ||
> +		     (skb_shinfo(skb)->gso_type & SKB_GSO_UDP_TUNNEL_CSUM);
> +	has_vlan =3D !!skb_vlan_tag_present(skb);
> +	vlan_tci =3D skb_vlan_tag_get(skb);
> +	encap =3D skb->encapsulation;
> +
> +	/* Preload inner-most TCP csum field with IP pseudo hdr
> +	 * calculated with IP length set to zero.  HW will later
> +	 * add in length to each TCP segment resulting from the TSO.
> +	 */
> +
> +	if (encap)
> +		err =3D ionic_tx_tcp_inner_pseudo_csum(skb);
> +	else
> +		err =3D ionic_tx_tcp_pseudo_csum(skb);
> +	if (err)
> +		return err;
> +
> +	if (encap)
> +		hdrlen =3D skb_inner_transport_header(skb) - skb->data +
> +			 inner_tcp_hdrlen(skb);
> +	else
> +		hdrlen =3D skb_transport_offset(skb) + tcp_hdrlen(skb);
> +
> +	seglen =3D hdrlen + mss;
> +	left =3D skb_headlen(skb);
> +
> +	desc =3D ionic_tx_tso_next(q, &elem);
> +	start =3D true;
> +
> +	/* Chop skb->data up into desc segments */
> +
> +	while (left > 0) {
> +		len =3D min(seglen, left);
> +		frag_left =3D seglen - len;
> +		desc_addr =3D ionic_tx_map_single(q, skb->data + offset, len);
> +		if (dma_mapping_error(dev, desc_addr))
> +			goto err_out_abort;
> +		desc_len =3D len;
> +		desc_nsge =3D 0;
> +		left -=3D len;
> +		offset +=3D len;
> +		if (nfrags > 0 && frag_left > 0)
> +			continue;
> +		done =3D (nfrags =3D=3D 0 && left =3D=3D 0);
> +		ionic_tx_tso_post(q, desc, skb,
> +				  desc_addr, desc_nsge, desc_len,
> +				  hdrlen, mss,
> +				  outer_csum,
> +				  vlan_tci, has_vlan,
> +				  start, done);
> +		total_pkts++;
> +		total_bytes +=3D start ? len : len + hdrlen;
> +		desc =3D ionic_tx_tso_next(q, &elem);
> +		start =3D false;
> +		seglen =3D mss;
> +	}
> +
> +	/* Chop skb frags into desc segments */
> +
> +	for (frag =3D skb_shinfo(skb)->frags; len_left; frag++) {
> +		offset =3D 0;
> +		left =3D skb_frag_size(frag);
> +		len_left -=3D left;
> +		nfrags--;
> +		stats->frags++;
> +
> +		while (left > 0) {
> +			if (frag_left > 0) {
> +				len =3D min(frag_left, left);
> +				frag_left -=3D len;
> +				elem->addr =3D
> +				    cpu_to_le64(ionic_tx_map_frag(q, frag,
> +								  offset, len));
> +				if (dma_mapping_error(dev, elem->addr))
> +					goto err_out_abort;
> +				elem->len =3D cpu_to_le16(len);
> +				elem++;
> +				desc_nsge++;
> +				left -=3D len;
> +				offset +=3D len;
> +				if (nfrags > 0 && frag_left > 0)
> +					continue;
> +				done =3D (nfrags =3D=3D 0 && left =3D=3D 0);
> +				ionic_tx_tso_post(q, desc, skb, desc_addr,
> +						  desc_nsge, desc_len,
> +						  hdrlen, mss, outer_csum,
> +						  vlan_tci, has_vlan,
> +						  start, done);
> +				total_pkts++;
> +				total_bytes +=3D start ? len : len + hdrlen;
> +				desc =3D ionic_tx_tso_next(q, &elem);
> +				start =3D false;
> +			} else {
> +				len =3D min(mss, left);
> +				frag_left =3D mss - len;
> +				desc_addr =3D ionic_tx_map_frag(q, frag,
> +							      offset, len);
> +				if (dma_mapping_error(dev, desc_addr))
> +					goto err_out_abort;
> +				desc_len =3D len;
> +				desc_nsge =3D 0;
> +				left -=3D len;
> +				offset +=3D len;
> +				if (nfrags > 0 && frag_left > 0)
> +					continue;
> +				done =3D (nfrags =3D=3D 0 && left =3D=3D 0);
> +				ionic_tx_tso_post(q, desc, skb, desc_addr,
> +						  desc_nsge, desc_len,
> +						  hdrlen, mss, outer_csum,
> +						  vlan_tci, has_vlan,
> +						  start, done);
> +				total_pkts++;
> +				total_bytes +=3D start ? len : len + hdrlen;
> +				desc =3D ionic_tx_tso_next(q, &elem);
> +				start =3D false;
> +			}
> +		}
> +	}
> +
> +	stats->pkts +=3D total_pkts;
> +	stats->bytes +=3D total_bytes;
> +	stats->tso++;
> +
> +	return 0;
> +
> +err_out_abort:
> +	while (rewind->desc !=3D q->head->desc) {
> +		ionic_tx_clean(q, rewind, NULL, NULL);
> +		rewind =3D rewind->next;
> +	}
> +	q->head =3D abort;
> +
> +	return -ENOMEM;
> +}

There's definitely a function for helping drivers which can't do full
TSO slice up the packet, but I can't find it now =F0=9F=98=AB=F0=9F=98=AB

Eric would definitely know.

Did you have a look? Would it be useful here?
