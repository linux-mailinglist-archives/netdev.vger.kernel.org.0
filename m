Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E43C5519613
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 05:37:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344404AbiEDDlS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 23:41:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344363AbiEDDlQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 23:41:16 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 728C1286DA
        for <netdev@vger.kernel.org>; Tue,  3 May 2022 20:37:37 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id j6so141356pfe.13
        for <netdev@vger.kernel.org>; Tue, 03 May 2022 20:37:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=lsBVjxx2frcPFNjY4/BLqdzh7cys7mpO3LyMH5LAbSE=;
        b=e/seADFb6dKCy5O35I2lb3QkGM1U1AG+HWJjIUEuWUaLYiQ/bRCqVwsL3BCOvWYEuK
         9qpY1aU7RmqPGGBT5JUv2H6Jc6siGFaT+PVsx+FN+n4iHis5NM0gOyiK9HY2IIWzLhh4
         mk3V/alwvU0/DDln8pB7kZALicerW3KUceFLU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=lsBVjxx2frcPFNjY4/BLqdzh7cys7mpO3LyMH5LAbSE=;
        b=bFzgYziaXJzbR2CIcIwQzukUs1jPPKV6Bv/NnFmyeKy2tXdAsGGcvhN6vy7gpI0blw
         4P8hZf/W/RQYLB0GJZvw/UHwN21Uf9e28fbm0Rdm1wl1LY26MX55kx7AIW8FUSYt26b0
         BJIIC0dD3kXRdzN+NOE6BYarMEXFYqYiDhhafPkn4Xl24JZwmVxvro1Gel/lBQml5mos
         /OPwasS5GT0JXV4LG01juRJEk0NkDevAxHV6Fw/rcnmAdHoy7D5XGSb8OQR0eSJ36fyA
         nSpL//K9By8bqz5fo1m6QoILWPxU5DE9CHtXsj27tQPhlZk4owNLXfI5DZV3zy2N78Si
         CAqQ==
X-Gm-Message-State: AOAM532mBpjeOWAbEexGZgmbIxrOP0OBY0A+dvEwpY8ZR33kSxDlC6Ea
        8RNHub3FZzN769JFkjUkCtZNoQ==
X-Google-Smtp-Source: ABdhPJwD/uvCKEJ4PY5hYyja46c4g0gVoPoVIrAV6/UTN/22EI1oLPF2GDVC1zkPD9qJOD+dW3FeWQ==
X-Received: by 2002:a63:8c1a:0:b0:3ab:35a9:5f8f with SMTP id m26-20020a638c1a000000b003ab35a95f8fmr16187660pgd.598.1651635457000;
        Tue, 03 May 2022 20:37:37 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id j17-20020a62b611000000b0050dc7628170sm7022939pff.74.2022.05.03.20.37.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 May 2022 20:37:36 -0700 (PDT)
Date:   Tue, 3 May 2022 20:37:35 -0700
From:   Kees Cook <keescook@chromium.org>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rich Felker <dalias@aerifal.cx>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        alsa-devel@alsa-project.org, Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Gabbasov <andrew_gabbasov@mentor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Gross <agross@kernel.org>,
        Andy Lavr <andy.lavr@gmail.com>,
        Arend van Spriel <aspriel@gmail.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Bradley Grove <linuxdrivers@attotech.com>,
        brcm80211-dev-list.pdl@broadcom.com,
        Christian Brauner <brauner@kernel.org>,
        Christian =?iso-8859-1?Q?G=F6ttsche?= <cgzones@googlemail.com>,
        Christian Lamparter <chunkeey@googlemail.com>,
        Chris Zankel <chris@zankel.net>,
        Cong Wang <cong.wang@bytedance.com>,
        Daniel Axtens <dja@axtens.net>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Dan Williams <dan.j.williams@intel.com>,
        David Gow <davidgow@google.com>,
        David Howells <dhowells@redhat.com>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        devicetree@vger.kernel.org, Dexuan Cui <decui@microsoft.com>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
        Eli Cohen <elic@nvidia.com>,
        Eric Paris <eparis@parisplace.org>,
        Eugeniu Rosca <erosca@de.adit-jv.com>,
        Felipe Balbi <balbi@kernel.org>,
        Francis Laniel <laniel_francis@privacyrequired.com>,
        Frank Rowand <frowand.list@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Gregory Greenman <gregory.greenman@intel.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Hulk Robot <hulkci@huawei.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        James Morris <jmorris@namei.org>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>,
        Jason Gunthorpe <jgg@ziepe.ca>, Jens Axboe <axboe@kernel.dk>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        John Keeping <john@metanate.com>,
        Juergen Gross <jgross@suse.com>, Kalle Valo <kvalo@kernel.org>,
        Keith Packard <keithp@keithp.com>, keyrings@vger.kernel.org,
        kunit-dev@googlegroups.com,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Lee Jones <lee.jones@linaro.org>,
        Leon Romanovsky <leon@kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        linux1394-devel@lists.sourceforge.net,
        linux-afs@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-hardening@vger.kernel.org, linux-hyperv@vger.kernel.org,
        linux-integrity@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-xtensa@linux-xtensa.org, llvm@lists.linux.dev,
        Loic Poulain <loic.poulain@linaro.org>,
        Louis Peens <louis.peens@corigine.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Mark Brown <broonie@kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Max Filippov <jcmvbkbc@gmail.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nuno =?iso-8859-1?Q?S=E1?= <nuno.sa@analog.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Paul Moore <paul@paul-moore.com>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>, selinux@vger.kernel.org,
        "Serge E. Hallyn" <serge@hallyn.com>,
        SHA-cyfmac-dev-list@infineon.com,
        Simon Horman <simon.horman@corigine.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Stephen Smalley <stephen.smalley.work@gmail.com>,
        Tadeusz Struk <tadeusz.struk@linaro.org>,
        Takashi Iwai <tiwai@suse.com>, Tom Rix <trix@redhat.com>,
        Udipto Goswami <quic_ugoswami@quicinc.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        wcn36xx@lists.infradead.org, Wei Liu <wei.liu@kernel.org>,
        xen-devel@lists.xenproject.org,
        Xiu Jianfeng <xiujianfeng@huawei.com>,
        Yang Yingliang <yangyingliang@huawei.com>
Subject: Re: [PATCH 01/32] netlink: Avoid memcpy() across flexible array
 boundary
Message-ID: <202205032027.B2A9FB4AA@keescook>
References: <20220504014440.3697851-1-keescook@chromium.org>
 <20220504014440.3697851-2-keescook@chromium.org>
 <20220504033105.GA13667@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220504033105.GA13667@embeddedor>
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 03, 2022 at 10:31:05PM -0500, Gustavo A. R. Silva wrote:
> On Tue, May 03, 2022 at 06:44:10PM -0700, Kees Cook wrote:
> [...]
> > diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
> > index 1b5a9c2e1c29..09346aee1022 100644
> > --- a/net/netlink/af_netlink.c
> > +++ b/net/netlink/af_netlink.c
> > @@ -2445,7 +2445,10 @@ void netlink_ack(struct sk_buff *in_skb, struct nlmsghdr *nlh, int err,
> >  			  NLMSG_ERROR, payload, flags);
> >  	errmsg = nlmsg_data(rep);
> >  	errmsg->error = err;
> > -	memcpy(&errmsg->msg, nlh, payload > sizeof(*errmsg) ? nlh->nlmsg_len : sizeof(*nlh));
> > +	errmsg->msg = *nlh;
> > +	if (payload > sizeof(*errmsg))
> > +		memcpy(errmsg->msg.nlmsg_payload, nlh->nlmsg_payload,
> > +		       nlh->nlmsg_len - sizeof(*nlh));
> 
> They have nlmsg_len()[1] for the length of the payload without the header:
> 
> /**
>  * nlmsg_len - length of message payload
>  * @nlh: netlink message header
>  */
> static inline int nlmsg_len(const struct nlmsghdr *nlh)
> {
> 	return nlh->nlmsg_len - NLMSG_HDRLEN;
> }

Oh, hm, yeah, that would be much cleaner. The relationship between
"payload" and nlmsg_len is confusing in here. :)

So, this should be simpler:

-	memcpy(&errmsg->msg, nlh, payload > sizeof(*errmsg) ? nlh->nlmsg_len : sizeof(*nlh));
+	errmsg->msg = *nlh;
+	memcpy(errmsg->msg.nlmsg_payload, nlh->nlmsg_payload, nlmsg_len(nlh));

It's actually this case that triggered my investigation in __bos(1)'s
misbehavior around sub-structs, since this case wasn't getting silenced:
https://gcc.gnu.org/bugzilla/show_bug.cgi?id=101832

It still feels like it should be possible to get this right without
splitting the memcpy, though. Hmpf.

> (would that function use some sanitization, though? what if nlmsg_len is
> somehow manipulated to be less than NLMSG_HDRLEN?...)

Maybe something like:

static inline int nlmsg_len(const struct nlmsghdr *nlh)
{
	if (WARN_ON(nlh->nlmsg_len < NLMSG_HDRLEN))
		return 0;
	return nlh->nlmsg_len - NLMSG_HDRLEN;
}

> Also, it seems there is at least one more instance of this same issue:
> 
> diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
> index 16ae92054baa..d06184b94af5 100644
> --- a/net/netfilter/ipset/ip_set_core.c
> +++ b/net/netfilter/ipset/ip_set_core.c
> @@ -1723,7 +1723,8 @@ call_ad(struct net *net, struct sock *ctnl, struct sk_buff *skb,
>                                   nlh->nlmsg_seq, NLMSG_ERROR, payload, 0);
>                 errmsg = nlmsg_data(rep);
>                 errmsg->error = ret;
> -               memcpy(&errmsg->msg, nlh, nlh->nlmsg_len);
> +               errmsg->msg = *nlh;
> +               memcpy(errmsg->msg.nlmsg_payload, nlh->nlmsg_payload, nlmsg_len(nlh));

Ah, yes, nice catch!

>                 cmdattr = (void *)&errmsg->msg + min_len;
> 
>                 ret = nla_parse(cda, IPSET_ATTR_CMD_MAX, cmdattr,
> 
> --
> Gustavo
> 
> [1] https://elixir.bootlin.com/linux/v5.18-rc5/source/include/net/netlink.h#L577

-- 
Kees Cook
