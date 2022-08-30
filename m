Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04D005A5C6B
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 09:05:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230340AbiH3HFS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 03:05:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230370AbiH3HFR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 03:05:17 -0400
Received: from mail-oa1-x33.google.com (mail-oa1-x33.google.com [IPv6:2001:4860:4864:20::33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94E622CCA2;
        Tue, 30 Aug 2022 00:05:14 -0700 (PDT)
Received: by mail-oa1-x33.google.com with SMTP id 586e51a60fabf-11f34610d4aso3906859fac.9;
        Tue, 30 Aug 2022 00:05:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=kYWohH57HrtiR3G5jR/2fpi0CaMLK4KnxnOm/MXWrNQ=;
        b=kAI1RG3rQl+TxxWuck7+8J10qVbuA1PCMdmiOGcOubN8F+pjSnkDLe0AMOwkjl11H1
         zxmyPbe0DM2OZLG6gfScChP7iWhMKwe7YOWTW+cnhSKUx37T5lMN+UxJZ1dE3VPlNdTL
         YtxYrizahOv0tio3ymXn1oLxtUu3aJyMKSeAwvN+/gUbqJxWSu5TFNbCyDQ9T98+l55e
         exHKjFuVbSDAzbQi+z7KT0vniQCNVs+S0cWezfLEVUW/ovAxmZFLFSxv/0kleUDB468Z
         tSTvcZSryEkOvg66sPufpHBozSsi/CV05ZSNSmzqaWWurRKPJEcmeI71Zh4qsq6SpwnJ
         B1rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=kYWohH57HrtiR3G5jR/2fpi0CaMLK4KnxnOm/MXWrNQ=;
        b=uKWzNLWZVRbnyvmV0jcKTDjtWyub6U62jOHt859PgHYvAQtMN6w+6+Xe5k9WfSWjVQ
         WAqTf5sK1hw0Zvo++Cbx5eI3TQP+3J4nPZCarpWT7XAePdGb2WqeYjnj/h8gU7OzChmp
         HVExV0x/7s0kxXrb5QzibeQ0Rn17tHN4dP5+90Q7kpn+KkTy2DFZ4zF68sFd0hGk5Ur8
         9VYxY/rbYmrhBJjXC8mZ0B2MTLPbjz6hapq4OwLDpbLE2ICdrS6rOyvIzgApKdQARBQ4
         iD8DJ3BDJKKt/+JN7b7AFOMv+yV1AtWBSKKOWxP2dnFqjLzC2Ap7x7KpgIH5IejP5jfS
         dvzQ==
X-Gm-Message-State: ACgBeo0Oo0NGmMLHrqxEmWnofO03ZB12eGgvVZD3fcyHp9KHvGcaAYy0
        G2RPBv4BEMR9TebMyK+kLowffKEHlK+WM/R8aJo=
X-Google-Smtp-Source: AA6agR6iDqDZpkAfemrVBNQR5IyP5DV+Nn8coE8ekGnmXxUZXafNRucloDJzxBU+nvKGN/PMZ8YvWlIZwafcrnWayC0=
X-Received: by 2002:a05:6808:201c:b0:343:b55:ae85 with SMTP id
 q28-20020a056808201c00b003430b55ae85mr8737545oiw.185.1661843112755; Tue, 30
 Aug 2022 00:05:12 -0700 (PDT)
MIME-Version: 1.0
References: <20220822071902.3419042-1-tcs_kernel@tencent.com>
 <f7e87879-1ac6-65e5-5162-c251204f07d4@datenfreihafen.org> <CAK-6q+hf27dY9d-FyAh2GtA_zG5J4kkHEX2Qj38Rac_PH63bQg@mail.gmail.com>
 <85f66a3a-95fa-5aaa-def0-998bf3f5139f@datenfreihafen.org>
In-Reply-To: <85f66a3a-95fa-5aaa-def0-998bf3f5139f@datenfreihafen.org>
From:   zhang haiming <tcs.kernel@gmail.com>
Date:   Tue, 30 Aug 2022 15:04:36 +0800
Message-ID: <CAB2z9exjHXMTA5dHFwdf0V+niQZ4ER00pT5Kwz2ybiRHqDC2ow@mail.gmail.com>
Subject: Re: [PATCH] net/ieee802154: fix uninit value bug in dgram_sendmsg
To:     Stefan Schmidt <stefan@datenfreihafen.org>
Cc:     Alexander Aring <aahringo@redhat.com>,
        Alexander Aring <alex.aring@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Haimin Zhang <tcs_kernel@tencent.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks to all.
I have sent patch v2 to fix this.

On Mon, Aug 29, 2022 at 5:08 PM Stefan Schmidt
<stefan@datenfreihafen.org> wrote:
>
>
> Hello Alex.
>
> On 23.08.22 14:22, Alexander Aring wrote:
> > Hi,
> >
> > On Tue, Aug 23, 2022 at 5:42 AM Stefan Schmidt
> > <stefan@datenfreihafen.org> wrote:
> >>
> >> Hello.
> >>
> >> On 22.08.22 09:19, Haimin Zhang wrote:
> >>> There is uninit value bug in dgram_sendmsg function in
> >>> net/ieee802154/socket.c when the length of valid data pointed by the
> >>> msg->msg_name isn't verified.
> >>>
> >>> This length is specified by msg->msg_namelen. Function
> >>> ieee802154_addr_from_sa is called by dgram_sendmsg, which use
> >>> msg->msg_name as struct sockaddr_ieee802154* and read it, that will
> >>> eventually lead to uninit value read. So we should check the length of
> >>> msg->msg_name is not less than sizeof(struct sockaddr_ieee802154)
> >>> before entering the ieee802154_addr_from_sa.
> >>>
> >>> Signed-off-by: Haimin Zhang <tcs_kernel@tencent.com>
> >>
> >>
> >> This patch has been applied to the wpan tree and will be
> >> part of the next pull request to net. Thanks!
> >
> > For me this patch is buggy or at least it is questionable how to deal
> > with the size of ieee802154_addr_sa here.
>
> You are right. I completely missed this. Thanks for spotting!
>
> > There should be a helper to calculate the size which depends on the
> > addr_type field. It is not required to send the last 6 bytes if
> > addr_type is IEEE802154_ADDR_SHORT.
> > Nitpick is that we should check in the beginning of that function.
>
> Haimin, in ieee802154 we could have two different sizes for
> ieee802154_addr_sa depending on the addr_type. We have short and
> extended addresses.
>
> Could you please rework this patch to take this into account as Alex
> suggested?
>
> I reverted your original patch from my tree.
>
> regards
> Stefan Schmidt
