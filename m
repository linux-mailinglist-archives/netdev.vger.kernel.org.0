Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7751687A55
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 11:34:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232688AbjBBKeY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 05:34:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232742AbjBBKeH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 05:34:07 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4186C5357E
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 02:33:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675333991;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gzY8WLXPZBGvGs13fwLVzvdB3zWOPAiALRIUHU5zbPE=;
        b=HX3sw/kLtwP5tF8sqMhVklj3nvz9t6maWcYUWCVg8k2SdF9lgoTUH34HH3ghAAvBE0NqRH
        uAT19aPatgyR0VF9SQivKH3/fYPFiRn95vLlyf39LOG+Zy7Y5E4Qy9oGOzRV4Kd+Z9Vqc0
        4NOleacIS6piJNIA7doV50VjIie2tbk=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-130-fRJVhBhdNB-fiKeA8fQBbw-1; Thu, 02 Feb 2023 05:33:07 -0500
X-MC-Unique: fRJVhBhdNB-fiKeA8fQBbw-1
Received: by mail-wm1-f72.google.com with SMTP id h9-20020a1ccc09000000b003db1c488826so2604828wmb.3
        for <netdev@vger.kernel.org>; Thu, 02 Feb 2023 02:33:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gzY8WLXPZBGvGs13fwLVzvdB3zWOPAiALRIUHU5zbPE=;
        b=Iia5eHIzll7nZ98eQWM8T8W964IWr6Q+HVyoLauvEuGeWTzSix4okPdhFIq08p6T8P
         ohMDytUlMVyOnccnK+ltZ9TYgpsy/IVC1c2P99h89NblG8Drtsn7SEe3bkr+tzNwv+5T
         QuHgIRLpQZ7EALNFB7MJq0MTCwuuIiw8sLVi99uEkAIZ/nWV0H3fl7uW3xBbO4wVLYyH
         VE0Ta9cdQRR+UVjRRVST6lcywMJ/1Ljrc4rs9X76sI9PRD5dx8eifkFZ+3voXK95Dhqo
         kdss1vnOJ1jzLn8uqYvMm2oCYJK7zIshvbZ94Lo+8Feh4bupoyE7BVRlVR6xfnnQdWdg
         JeLw==
X-Gm-Message-State: AO0yUKWaEeaSyQ2VqHghRjC24IFwCoaVA4HQHouYc3I2a+OpQFYmkzf2
        CSVj8BjeOLzphKm0NP0SJrnEmgCYbdnmNqDETDAdvymyRxFIe9fYaSY6PQHkeEInQn0n2ao07gO
        3GRue068ImqfXcOvO
X-Received: by 2002:a05:600c:4e4e:b0:3d2:bca5:10a2 with SMTP id e14-20020a05600c4e4e00b003d2bca510a2mr5273855wmq.22.1675333984808;
        Thu, 02 Feb 2023 02:33:04 -0800 (PST)
X-Google-Smtp-Source: AK7set/fHx8aUDAB0froK+lS+HWGLVJXUV/PDw9YBioywtgcQQqxlZhTuxBLUkkhhVkUE0oQ07IROQ==
X-Received: by 2002:a05:600c:4e4e:b0:3d2:bca5:10a2 with SMTP id e14-20020a05600c4e4e00b003d2bca510a2mr5273840wmq.22.1675333984603;
        Thu, 02 Feb 2023 02:33:04 -0800 (PST)
Received: from redhat.com ([2a02:14f:1fc:826d:55d8:70a4:3d30:fc2f])
        by smtp.gmail.com with ESMTPSA id p11-20020a1c544b000000b003dc4fd6e624sm4452688wmi.19.2023.02.02.02.33.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Feb 2023 02:33:03 -0800 (PST)
Date:   Thu, 2 Feb 2023 05:32:59 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Shunsuke Mie <mie@igel.co.jp>
Cc:     Jason Wang <jasowang@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 1/7] vringh: fix a typo in comments for vringh_kiov
Message-ID: <20230202053204-mutt-send-email-mst@kernel.org>
References: <20230202090934.549556-1-mie@igel.co.jp>
 <20230202090934.549556-2-mie@igel.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230202090934.549556-2-mie@igel.co.jp>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 02, 2023 at 06:09:28PM +0900, Shunsuke Mie wrote:
> Probably it is a simple copy error from struct vring_iov.
> 
> Fixes: f87d0fbb5798 ("vringh: host-side implementation of virtio rings.")
> Signed-off-by: Shunsuke Mie <mie@igel.co.jp>

Drop the fixes tag pls it's not really relevantfor comments.
But the patch is correct, pls submit separately we can
already apply this.

> ---
>  include/linux/vringh.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/linux/vringh.h b/include/linux/vringh.h
> index 212892cf9822..1991a02c6431 100644
> --- a/include/linux/vringh.h
> +++ b/include/linux/vringh.h
> @@ -92,7 +92,7 @@ struct vringh_iov {
>  };
>  
>  /**
> - * struct vringh_iov - kvec mangler.
> + * struct vringh_kiov - kvec mangler.
>   *
>   * Mangles kvec in place, and restores it.
>   * Remaining data is iov + i, of used - i elements.
> -- 
> 2.25.1

