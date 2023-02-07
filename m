Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D5EC68DFFF
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 19:27:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232109AbjBGS1l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 13:27:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232486AbjBGS1g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 13:27:36 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28942974F
        for <netdev@vger.kernel.org>; Tue,  7 Feb 2023 10:27:26 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id jg8so5291962ejc.6
        for <netdev@vger.kernel.org>; Tue, 07 Feb 2023 10:27:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=diag.uniroma1.it; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=G3C5mOidhZDrCqJ4TYEcLxCaPp0/cnlYAYlnw8sD9bM=;
        b=MqwIFpgzZ4IuhdKcIoI4RWMlnojYLVxPhx1w9n0b0bMhcRyOF1ZsDrlj/SyZ+xCvEJ
         d2Vb7A6wC6xCHddTYK4/jZrID4K7sAyzOTyKQZ8Cxz94DxsSfEvTY3Jto67sfGRvCuOE
         OAlhG/6RrflvFGfTDUpD4PWLjcuG96phtOy5I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=G3C5mOidhZDrCqJ4TYEcLxCaPp0/cnlYAYlnw8sD9bM=;
        b=d0K1phfePQBIlLoCURjtO7MrVTY4YnPAcWS2bau0NG+96xUYC7hOS6++NglGLFq6o1
         CPU+axRzH9DmKEIfz/1fYWY/pE3pyJHOWuVw19Itiqeansb/ACBbHQEzJbq8iYLuG9gF
         p3hKljy/49nByI2VGxlrpNfL0OZ+/CCnTT42i6fx4pnZN3khwBLvTewkwx5HbKokzZ3f
         A+GDLnZv9HVN6KE1ldOYtvfQK0Gc7N+h2GPXeaEqaRpEsxYEDQNvLkT9LD+TU5oEOtOi
         LxQZpWItBeDdNqTUZ1A3zgnHL5Ov+veB1xAmM2akrJZpGP5d7eBKHKHzKXctsItY8paI
         9VuA==
X-Gm-Message-State: AO0yUKX1d2BQtBujV7KiHTDFzE1x4ueGT3BtpSO6YtT2s6QLDP+bhc4h
        sou/yblrrYAsZJJ3VdvKcdr+6QItoHXZ3OEzrAlSyg==
X-Google-Smtp-Source: AK7set8S8b3O/e4b4YJvSR/iy27GoOfLbU1kyTqsS0lIGxBOIHzb9qmJyo4USffDoWiXrB/8GqUfxADEss5NDfdZZc8=
X-Received: by 2002:a17:906:37c2:b0:878:7bc7:958a with SMTP id
 o2-20020a17090637c200b008787bc7958amr1091575ejc.220.1675794444795; Tue, 07
 Feb 2023 10:27:24 -0800 (PST)
MIME-Version: 1.0
References: <20230202-rds-zerocopy-v2-1-c999755075db@diag.uniroma1.it> <CA+FuTSftbF=xwWd_kJHuJ9hQ3PYFOT48r_TazEDVaH8GkrQ2+g@mail.gmail.com>
In-Reply-To: <CA+FuTSftbF=xwWd_kJHuJ9hQ3PYFOT48r_TazEDVaH8GkrQ2+g@mail.gmail.com>
From:   Pietro Borrello <borrello@diag.uniroma1.it>
Date:   Tue, 7 Feb 2023 19:27:14 +0100
Message-ID: <CAEih1qV5wNE3Q6AEJ2ERa3geoW8LBe4puuCXwfOD95uw7FU=bQ@mail.gmail.com>
Subject: Re: [PATCH net-next v2] rds: rds_rm_zerocopy_callback() use list_first_entry()
To:     Willem de Bruijn <willemb@google.com>
Cc:     Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Cristiano Giuffrida <c.giuffrida@vu.nl>,
        "Bos, H.J." <h.j.bos@vu.nl>, Jakob Koschel <jkl820.git@gmail.com>,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        rds-devel@oss.oracle.com, linux-kernel@vger.kernel.org,
        sowmini.varadhan@oracle.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 7 Feb 2023 at 19:21, Willem de Bruijn <willemb@google.com> wrote:
>
> On Tue, Feb 7, 2023 at 9:57 AM Pietro Borrello
> <borrello@diag.uniroma1.it> wrote:
> >
> > rds_rm_zerocopy_callback() uses list_entry() on the head of a list
> > causing a type confusion.
> > Use list_first_entry() to actually access the first element of the
> > rs_zcookie_queue list.
> >
> > Fixes: 9426bbc6de99 ("rds: use list structure to track information for zerocopy completion notification")
> > Signed-off-by: Pietro Borrello <borrello@diag.uniroma1.it>
>
> This should go to net.

Ops, fixed in v3

>
> Reviewed-by: Willem de Bruijn <willemb@google.com>
