Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CD8258FB34
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 13:24:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234771AbiHKLX7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 07:23:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234763AbiHKLX6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 07:23:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 869C111C0A
        for <netdev@vger.kernel.org>; Thu, 11 Aug 2022 04:23:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660217034;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QDxPkPA/Vk3OxCoIfjmUcXBTKk9JZQyuU+Qz9bpxhDI=;
        b=ZskuBdCe8c0Mx7lmRJ7qzlKvk0+fkCOi9gRDg9VSn3HoMNd5OdxQIv2EwGSpuc/wyhvpbl
        Dn2DRjfPw++SsGEa21NRBkiVY9nljregeKRFmHskJ5/buQi9AGdU79UYYMtoGoTVVP44yl
        wNP5TIrPdULgn06H0c0JV1yBKNZXlO8=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-490-rsjsBGctNEmQPg4Lok1_pw-1; Thu, 11 Aug 2022 07:23:53 -0400
X-MC-Unique: rsjsBGctNEmQPg4Lok1_pw-1
Received: by mail-wm1-f70.google.com with SMTP id j22-20020a05600c485600b003a50fa6981bso2486241wmo.9
        for <netdev@vger.kernel.org>; Thu, 11 Aug 2022 04:23:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc;
        bh=QDxPkPA/Vk3OxCoIfjmUcXBTKk9JZQyuU+Qz9bpxhDI=;
        b=7e3Qk7SqpzGlAMiXul54+d8o5mwSp6pZp+BzgJe1pzBUO1O0OEu3JQZUF/RZLbI0AL
         xRIXJkpkfcDWXov1b3EAKPcUj7EmnFq9bv3pSzYgYUNuXMlMN6NXMureJn/BTTbnotSo
         P4daG2L6UT+5d0ZN15yO0onorazHPibwsmGkF5l2JgiJ+590l9EL11X1mpBeKtbNmOUw
         FrSv7pJy928MLXpQ6W0SAXNmZ+bJwZ4RE1Ki0aytxLZONPFj3t2aVAbFx9dstoRKyCzK
         jyAsTHN9WGcyWMhoHAn6HAUfq0ZCufj0IgLoIO0kCvdOfqmnc3+kBD3wdimiVShTXpql
         2WEg==
X-Gm-Message-State: ACgBeo3gczmOziwbauXxyY3leCRY9KdiRaB1DZ7PjKtBpzpowK7sEoNj
        BVX3lrpeKMUVjWmLSxKwn7FWKAuy+1DLYDOfA9YMi6QlZDK89yfsShVDhXw/tBK2FcOswH1vUOm
        kjrAmx9HNqjerRhM3
X-Received: by 2002:a5d:6d49:0:b0:21b:a3ba:30b5 with SMTP id k9-20020a5d6d49000000b0021ba3ba30b5mr20332445wri.513.1660217032224;
        Thu, 11 Aug 2022 04:23:52 -0700 (PDT)
X-Google-Smtp-Source: AA6agR77S6dIzOGsnWQiMM//cWa1GSRI2vnhXId8PTMJGmuNW0RZNb5joCOLTnulYlpkcuj3mY6sIw==
X-Received: by 2002:a5d:6d49:0:b0:21b:a3ba:30b5 with SMTP id k9-20020a5d6d49000000b0021ba3ba30b5mr20332411wri.513.1660217031983;
        Thu, 11 Aug 2022 04:23:51 -0700 (PDT)
Received: from redhat.com ([2.52.152.113])
        by smtp.gmail.com with ESMTPSA id n33-20020a05600c502100b003a5c21c543dsm1192075wmr.7.2022.08.11.04.23.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Aug 2022 04:23:51 -0700 (PDT)
Date:   Thu, 11 Aug 2022 07:23:44 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        dinang@xilinx.com, martinpo@xilinx.com,
        Wu Zongyong <wuzongyong@linux.alibaba.com>,
        Piotr.Uminski@intel.com, gautam.dawar@amd.com,
        ecree.xilinx@gmail.com, martinh@xilinx.com,
        Stefano Garzarella <sgarzare@redhat.com>, pabloc@xilinx.com,
        habetsm.xilinx@gmail.com, lvivier@redhat.com,
        Zhu Lingshan <lingshan.zhu@intel.com>, tanuj.kamde@amd.com,
        Longpeng <longpeng2@huawei.com>, lulu@redhat.com,
        hanand@xilinx.com, Parav Pandit <parav@nvidia.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>,
        Eli Cohen <elic@nvidia.com>,
        Xie Yongji <xieyongji@bytedance.com>,
        Zhang Min <zhang.min9@zte.com.cn>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: Re: [PATCH v7 1/4] vdpa: Add suspend operation
Message-ID: <20220811072125-mutt-send-email-mst@kernel.org>
References: <20220810171512.2343333-1-eperezma@redhat.com>
 <20220810171512.2343333-2-eperezma@redhat.com>
 <20220811042717-mutt-send-email-mst@kernel.org>
 <20220811101507.GU3460@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220811101507.GU3460@kadam>
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 11, 2022 at 01:15:08PM +0300, Dan Carpenter wrote:
> On Thu, Aug 11, 2022 at 04:27:32AM -0400, Michael S. Tsirkin wrote:
> > On Wed, Aug 10, 2022 at 07:15:09PM +0200, Eugenio Pérez wrote:
> > > This operation is optional: It it's not implemented, backend feature bit
> > > will not be exposed.
> > > 
> > > Signed-off-by: Eugenio Pérez <eperezma@redhat.com>
> > > Message-Id: <20220623160738.632852-2-eperezma@redhat.com>
> > > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > 
> > What is this message id doing here?
> > 
> 
> I like the Message-Id tag.  It means you can `b4 mbox <mesg-id>` and get
> the thread.

Yes it makes sense in git. But I don't see what it does in this patch
posted to the list. It seems to refer to the previous version of the
patch here. Which is ok I guess but better called out e.g.

Previous-version: <20220623160738.632852-2-eperezma@redhat.com>


> Linus has complained (rough remembering) that everyone is using the
> Link: tag for links to the patch itself.  It's supposed to be for Links
> to bugzilla or to the spec or whatever.  Extra information, too much to
> put in the commit message.  Now the Link tag is useless because it either
> points to the patch or to a bugzilla.  Depend on what you want it to do,
> it *always* points to the opposite thing.
> 
> But I can't remember what people settled on as the alternative to use
> to link to lore...
> 
> In theory, we should be able to figure out the link to lore automatically
> and there have been a couple projects which tried to do this but they
> can't make it work 100%.  Maintainers massage and reformat the patches
> too much before applying them.
> 
> regards,
> dan carpenter

