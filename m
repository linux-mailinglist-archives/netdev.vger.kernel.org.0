Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9785B58F990
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 10:53:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234775AbiHKIxS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 04:53:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234772AbiHKIxR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 04:53:17 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3807F915F8
        for <netdev@vger.kernel.org>; Thu, 11 Aug 2022 01:53:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660207995;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lJ6dO5FkJbRlPuu7ETIUoBKLHvygzrFjGVpCJhy/afY=;
        b=FISvsLL9AIRklPe3jUWy152LyJMShmT0b+K/kroUwJtsPfCE+jifgbXQnFOLJCL7DyatV7
        080iVo20G2/mylcRLw/7qWVHuzbnDLj8iQIxMnUfAvqL1Rjg8FCWBPk/yG2/ZoDtmjdYZt
        kNFuD/y+OJCBqOvgUQOF9UI9M5K/Vrc=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-446-AtDKlrpLMDWwWVKBZ6wu6Q-1; Thu, 11 Aug 2022 04:53:13 -0400
X-MC-Unique: AtDKlrpLMDWwWVKBZ6wu6Q-1
Received: by mail-ed1-f72.google.com with SMTP id z3-20020a056402274300b0043d4da3b4b5so10442554edd.12
        for <netdev@vger.kernel.org>; Thu, 11 Aug 2022 01:53:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=lJ6dO5FkJbRlPuu7ETIUoBKLHvygzrFjGVpCJhy/afY=;
        b=DPbZzXHkHoIr33ZYLoI2sC3+zsdTBKGZrZP4fmHH6gF9wL2BJb6o3RNKAKCAbnw0ZU
         +7n3SD3YzSLEGoPiq8c5WtB1pXKR/Rji/tbBb8+WsV6/xGJhWNg6En50MlDXUQN6DoQV
         wclp5rN8T+84lSiv8zkKbQCqwy/i5dJsm2m03XPAxX1LZBna9fxdDpd0D7RCdjJBJkfO
         69Ct7H52PJcTQHW8eUpQThmTb/up22z6YPYk2AgX8ohRCchwAmvG2tBVTPAkXvfjJWO7
         1r5Vo+tH1i529VnBrT5NQVNSCbwi9dndV7q3jpxipfz+evoBxpN39PKtHVSalGt9+jR/
         cFTQ==
X-Gm-Message-State: ACgBeo2ZUJiVdt/AMSt6rD7Vj0FFb3LAEQ73CaQocEduHyIlSBBddjg+
        MGQbpjXjVIqxJOi3pXBd8gtsC7+penYVd6CHNR8R4kMVuvZ5MbF340v2TiclC3C3sNTCNoMiTYz
        59FBnKRQrAE3KnqVV
X-Received: by 2002:a17:907:3e06:b0:733:693:600e with SMTP id hp6-20020a1709073e0600b007330693600emr5126997ejc.410.1660207992764;
        Thu, 11 Aug 2022 01:53:12 -0700 (PDT)
X-Google-Smtp-Source: AA6agR4/6esuEFdoJ5rOUNg2auAt+loCsh2rGaNBovidkUuVarDYw91Xl8Xc9+Wbs3oYAcm7LRxQiA==
X-Received: by 2002:a17:907:3e06:b0:733:693:600e with SMTP id hp6-20020a1709073e0600b007330693600emr5126985ejc.410.1660207992576;
        Thu, 11 Aug 2022 01:53:12 -0700 (PDT)
Received: from redhat.com ([2.52.152.113])
        by smtp.gmail.com with ESMTPSA id k21-20020aa7c395000000b0043cc66d7accsm8823638edq.36.2022.08.11.01.53.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Aug 2022 01:53:12 -0700 (PDT)
Date:   Thu, 11 Aug 2022 04:53:08 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Andrew Melnychenko <andrew@daynix.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kuba@kernel.org,
        davem@davemloft.net, jasowang@redhat.com, yan@daynix.com,
        yuri.benditovich@daynix.com
Subject: Re: [PATCH v5 3/4] drivers/net/virtio_net: Added RSS hash report.
Message-ID: <20220811045005-mutt-send-email-mst@kernel.org>
References: <20220328175336.10802-1-andrew@daynix.com>
 <20220328175336.10802-4-andrew@daynix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220328175336.10802-4-andrew@daynix.com>
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 28, 2022 at 08:53:35PM +0300, Andrew Melnychenko wrote:
> +static void virtio_skb_set_hash(const struct virtio_net_hdr_v1_hash *hdr_hash,
> +				struct sk_buff *skb)
> +{
> +	enum pkt_hash_types rss_hash_type;
> +
> +	if (!hdr_hash || !skb)
> +		return;
> +
> +	switch ((int)hdr_hash->hash_report) {
> +	case VIRTIO_NET_HASH_REPORT_TCPv4:
> +	case VIRTIO_NET_HASH_REPORT_UDPv4:
> +	case VIRTIO_NET_HASH_REPORT_TCPv6:
> +	case VIRTIO_NET_HASH_REPORT_UDPv6:
> +	case VIRTIO_NET_HASH_REPORT_TCPv6_EX:
> +	case VIRTIO_NET_HASH_REPORT_UDPv6_EX:
> +		rss_hash_type = PKT_HASH_TYPE_L4;
> +		break;
> +	case VIRTIO_NET_HASH_REPORT_IPv4:
> +	case VIRTIO_NET_HASH_REPORT_IPv6:
> +	case VIRTIO_NET_HASH_REPORT_IPv6_EX:
> +		rss_hash_type = PKT_HASH_TYPE_L3;
> +		break;
> +	case VIRTIO_NET_HASH_REPORT_NONE:
> +	default:
> +		rss_hash_type = PKT_HASH_TYPE_NONE;
> +	}
> +	skb_set_hash(skb, (unsigned int)hdr_hash->hash_value, rss_hash_type);
> +}
> +
>  static void receive_buf(struct virtnet_info *vi, struct receive_queue *rq,
>  			void *buf, unsigned int len, void **ctx,
>  			unsigned int *xdp_xmit,

I just noticed this- endian-ness broken here, you need _le16_to_cpu for
hash_report and __le_32_to_cpu for hash_value.

-- 
MST

