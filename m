Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E49965C9A6
	for <lists+netdev@lfdr.de>; Tue,  3 Jan 2023 23:27:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238952AbjACW1z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 17:27:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238189AbjACW12 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 17:27:28 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D05818B0D
        for <netdev@vger.kernel.org>; Tue,  3 Jan 2023 14:24:54 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id o31-20020a17090a0a2200b00223fedffb30so32549683pjo.3
        for <netdev@vger.kernel.org>; Tue, 03 Jan 2023 14:24:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=bAbM53LNtbuBpzdcSH7t+85XAJK+yI8Er92lPi4rqp8=;
        b=l6737WId1PWVXlNkiVbGXzlggzeFv/u6k2sKSGbbAh393OeuqkfFYwe92dbku7ocqV
         /BHUYYvrYHii56WYoLF2pQdK9KgmsUg6Tp0eq0ulNYOfWrbMqeIp2VCAM1BE33LekOMs
         pf7kXamUa9KUY91CAQ/5JDyn3Lj0TpcYtQr3yIaP7etkpLKvV9LuGEs/mkWNgXPTY6Cy
         9aLPzzt2Y65jxZMhWXmGB4ra11wTh/EGbZPYLROqyR5DpvDMWMttMMyWBFWTwLL/kPVV
         wXOkFH2kZ7Uu7R9XLl/i7jrbaNW3z5Fj9Mpj2i6gXO/IesRlAmxT/wzOFmJSz5YUJCcz
         Kq/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bAbM53LNtbuBpzdcSH7t+85XAJK+yI8Er92lPi4rqp8=;
        b=kj4STQfTaGUJ2qTqY605gDPExliWcOChIzNYToQSkbziDJE/MG+bWwxrtSpU3AL619
         XOIhbB7TDBSAjAflcj+PlKf5plixnZesJJMGSaF45qMuCnDXGnfW16Rcn2ETDGQ6js81
         WVzQp5lXU2CnWMJOyByb/zqyFibU1gPgZEqSJfKyHwjAFQ0PXYeBgssSDK1J7mTgwlFx
         QfHsg0bLKWximWk0MO9yxQNb8pEOxchjhPV1u41GCfFHW8fFDiJeFsQ5vXBxVe6XDYW/
         PptJARACCW4FRxMRttpl5Pr0FsypyYGWzNnAWGWW+PR32DI3+vK1bbFqN22Nxf99nIn/
         h+/A==
X-Gm-Message-State: AFqh2kp3Iw8Vbdbyv2X3qtZWJFEF3d28T/h9EMe8hOV85wbST04Z4baE
        tioxVO/YC4OkwKNCRFNmDi7Bp2LW9RBUVSqBuL9oUg==
X-Google-Smtp-Source: AMrXdXtg7m2W/dxg/F5rD1x5L5XTSt6raEoUW0DUarorcyprjvNPBarxEkpgok1K/u9DYAm9nqBZIfMzvNxmtDg6kW4=
X-Received: by 2002:a17:903:2696:b0:189:e426:463e with SMTP id
 jf22-20020a170903269600b00189e426463emr2064365plb.134.1672784650435; Tue, 03
 Jan 2023 14:24:10 -0800 (PST)
MIME-Version: 1.0
References: <20221220222043.3348718-1-sdf@google.com> <20221220222043.3348718-8-sdf@google.com>
 <Y6tWrtltKfAlo0rT@maniforge.lan>
In-Reply-To: <Y6tWrtltKfAlo0rT@maniforge.lan>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Tue, 3 Jan 2023 14:23:59 -0800
Message-ID: <CAKH8qBseZ_ceu1A4Cyt_NND9ZcFRapu-74CugPYBfooppXF3xA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v5 07/17] bpf: XDP metadata RX kfuncs
To:     David Vernet <void@manifault.com>
Cc:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, martin.lau@linux.dev, song@kernel.org,
        yhs@fb.com, john.fastabend@gmail.com, kpsingh@kernel.org,
        haoluo@google.com, jolsa@kernel.org,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 27, 2022 at 12:33 PM David Vernet <void@manifault.com> wrote:
>
> On Tue, Dec 20, 2022 at 02:20:33PM -0800, Stanislav Fomichev wrote:
>
> Hey Stanislav,
>
> [...]
>
> > diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> > index aad12a179e54..b41d18490595 100644
> > --- a/include/linux/netdevice.h
> > +++ b/include/linux/netdevice.h
> > @@ -74,6 +74,7 @@ struct udp_tunnel_nic_info;
> >  struct udp_tunnel_nic;
> >  struct bpf_prog;
> >  struct xdp_buff;
> > +struct xdp_md;
> >
> >  void synchronize_net(void);
> >  void netdev_set_default_ethtool_ops(struct net_device *dev,
> > @@ -1618,6 +1619,11 @@ struct net_device_ops {
> >                                                 bool cycles);
> >  };
> >
> > +struct xdp_metadata_ops {
> > +     int     (*xmo_rx_timestamp)(const struct xdp_md *ctx, u64 *timestamp);
> > +     int     (*xmo_rx_hash)(const struct xdp_md *ctx, u32 *hash);
> > +};
> > +
> >  /**
> >   * enum netdev_priv_flags - &struct net_device priv_flags
> >   *
> > @@ -2050,6 +2056,7 @@ struct net_device {
> >       unsigned int            flags;
> >       unsigned long long      priv_flags;
> >       const struct net_device_ops *netdev_ops;
> > +     const struct xdp_metadata_ops *xdp_metadata_ops;
>
> You need to document this field above the struct, or the docs build will
> complain:
>
>   SPHINX  htmldocs -->
>   <redacted>
>   make[2]: Nothing to be done for 'html'.
>   Using sphinx_rtd_theme theme
>   source directory: networking
>   ./include/linux/netdevice.h:2371: warning: Function parameter or
>   member 'xdp_metadata_ops' not described in 'net_device'
>
> >       int                     ifindex;
> >       unsigned short          gflags;
> >       unsigned short          hard_header_len;

Thanks, I will try to actually build the doc. Last time I tried it
took too long and I gave up :-)

> Thanks,
> David
