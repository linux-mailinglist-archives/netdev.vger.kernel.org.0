Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81BAA594EEB
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 05:03:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232967AbiHPDCs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Aug 2022 23:02:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232960AbiHPDBm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Aug 2022 23:01:42 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 047152DF6B6
        for <netdev@vger.kernel.org>; Mon, 15 Aug 2022 16:35:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660606516;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5zb/VZQAOIgiltymKi0EU4LqXYPn7kX2Sef7eElYFw8=;
        b=Ss82UcWPcDLgGGFhCg3gKeFJJieHjvHtBFX3G8/n8ZFc7HrYzElwOZ9t9Gtd8UohB0BK5Y
        xvt4jtFxm6nFGB+FhyEPi7scZEZzAKIGQjtXpjf+dVc/JUGceezwol6rBxLZrvCZLw11OF
        govagc2II2AkzINnD4dHAiCklE/goMI=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-460-2TxUTYaoPzabCAJLONSnEw-1; Mon, 15 Aug 2022 19:35:15 -0400
X-MC-Unique: 2TxUTYaoPzabCAJLONSnEw-1
Received: by mail-wm1-f71.google.com with SMTP id f18-20020a05600c4e9200b003a5f81299caso1051106wmq.7
        for <netdev@vger.kernel.org>; Mon, 15 Aug 2022 16:35:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=5zb/VZQAOIgiltymKi0EU4LqXYPn7kX2Sef7eElYFw8=;
        b=K+t1OlOuSwAIgjyef89IhFd85ZzFiqCeN3/R9A1TSr7Qe6PC6FC12wn7QBY8u7o/bL
         LHS7EyGAlhPb1OL/eh7SWViXihafyWr1B2mhPWoxyU+9eKqODKxeT/gsHC3upnlFR4Ko
         HcmESrJsyh3SNVHhoWrIQr40YxU0MLJgKKVLQ8DAh1yy/3r5kkBasdoyo6+3hm1sx9rA
         rBcEhPguqd0zFSSUnQxX+VYgXTCUZvCE6s69zRAzAqeJGnYvZezbfbttBGG78n1zHM3H
         flYuN+4La4q3jnx/RQQRfub6y1iGvTnb5WpztAZILFYJlmZxtGa3d00COUn2t6rlTZkp
         xP8w==
X-Gm-Message-State: ACgBeo02M8W5stYw3JxTvatFOwH1Zvin3lZ8XUkuVuT6uUeQow7a5RZd
        fikeboqapFzBO/c9PxLTGQIHQCnlcxb2k0bfG1fGx3el8espXvL23MOo/WsJ6/sR1vq9Jh9hrLG
        f0LKIiKypnCW7LFiJ
X-Received: by 2002:adf:e68c:0:b0:223:a74e:7e63 with SMTP id r12-20020adfe68c000000b00223a74e7e63mr9161866wrm.603.1660606513924;
        Mon, 15 Aug 2022 16:35:13 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7edmzM0cGxVsTi8/QYJs2FLXSn76zA+W0PpmBcUpfrSpvST9v2wXq+kEHGhFwDZ7zGXJdYvw==
X-Received: by 2002:adf:e68c:0:b0:223:a74e:7e63 with SMTP id r12-20020adfe68c000000b00223a74e7e63mr9161853wrm.603.1660606513724;
        Mon, 15 Aug 2022 16:35:13 -0700 (PDT)
Received: from redhat.com ([2.55.43.215])
        by smtp.gmail.com with ESMTPSA id n18-20020a05600c501200b003a545fe9db4sm11056782wmr.23.2022.08.15.16.35.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Aug 2022 16:35:12 -0700 (PDT)
Date:   Mon, 15 Aug 2022 19:35:07 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-kernel@vger.kernel.org,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v3 0/5] virtio: drop sizing vqs during init
Message-ID: <20220815193438-mutt-send-email-mst@kernel.org>
References: <20220815215938.154999-1-mst@redhat.com>
 <CAHk-=wj=Ju_jhbww7WmpgmHHebMSdd1U5WBjh925yLB_F1j9Ng@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wj=Ju_jhbww7WmpgmHHebMSdd1U5WBjh925yLB_F1j9Ng@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 15, 2022 at 03:24:28PM -0700, Linus Torvalds wrote:
> On Mon, Aug 15, 2022 at 3:00 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> >
> > But the benefit is unclear in any case, so let's revert for now.
> 
> Should I take this patch series directly, or will you be sending a
> pull request (preferred)?
> 
>              Linus

I'll be sending a pull request, just not today - I try not to do
this at strange hours of night.

-- 
MST

