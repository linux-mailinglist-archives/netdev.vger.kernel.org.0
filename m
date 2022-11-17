Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C008062D7FE
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 11:28:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234903AbiKQK2M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 05:28:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239263AbiKQK2I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 05:28:08 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57A58532C6
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 02:27:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668680827;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xlbf4XMXjAAtZtTfrsNX3coW79/AxwrRMideQvPGziY=;
        b=bET3uoQtbrsQK/yVauVZm41145LBFctSn3JtWB/o+SROC1V2yd1Nf9OAhoByMPxkPDTY7P
        COYFnQrbfkFObtKVCGVC0EwYMZPJTmlca6+ouke9og/S44CEqMnPpyOB8bU/G2dW2OFt6Y
        ol8t+09peNJKh+Qpc6F9CEUbJD/mz2g=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-209-NBTG--2eOuqQoH6eNJwCqQ-1; Thu, 17 Nov 2022 05:27:05 -0500
X-MC-Unique: NBTG--2eOuqQoH6eNJwCqQ-1
Received: by mail-ed1-f71.google.com with SMTP id g14-20020a056402090e00b0046790cd9082so939139edz.21
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 02:27:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xlbf4XMXjAAtZtTfrsNX3coW79/AxwrRMideQvPGziY=;
        b=VSosYWw0o7G285smDx9UDaufao5c+jRUxmE5zX365faqobhIP2H66JBeJ1IisaF9EE
         q1dmi26Gg4enZO5e0c0X+c6lGpzTeSWoDTtFpj+I0Y5qizM9lZgkt5rxZaHLe7Y0H4xj
         7PwAp85WFKCp3AGaH71qKfqUpA5Zq5cDLGOV8E4yDD/RI8VrKtL0rNUiqMukI08Rrhss
         ohM9puJX+axOQBFlk7oajEzfhui84JZ25cueUhPmU3Bc/uwU+kscuAWBx8eqwQTGQhU8
         51AaICafPrXgvL+Gs4dJu9SGihi7cn6WY9e8vxwL1ngjkEF5auWf2N+UpBw5jBcKtpuS
         zLPw==
X-Gm-Message-State: ANoB5pnkeS1K++b89lhRziXjQU43dzFeaz4kJiAmd91RxnOoF8skdsiY
        VX6hp7Kqpq0zghtoghDQI61pbDpwpHVLuZmSCBtOYmjIOk5331NBcYuvbJJsGfimOjKFbb3rlaX
        MEbv1qmBFlpe1J9IV
X-Received: by 2002:a17:906:254f:b0:7ac:d0ae:feba with SMTP id j15-20020a170906254f00b007acd0aefebamr1573805ejb.646.1668680824257;
        Thu, 17 Nov 2022 02:27:04 -0800 (PST)
X-Google-Smtp-Source: AA0mqf7LIpp0Gv2shAYk1X+0qGt/Bbdy+J07gPYzUVDRuy1tpjEPTaB+4v//C8khZ3yBq2rJTWDoAw==
X-Received: by 2002:a17:906:254f:b0:7ac:d0ae:feba with SMTP id j15-20020a170906254f00b007acd0aefebamr1573792ejb.646.1668680823936;
        Thu, 17 Nov 2022 02:27:03 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id d23-20020a056402001700b00461aca1c7b6sm351336edu.6.2022.11.17.02.27.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Nov 2022 02:27:03 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id D11907A6F2C; Thu, 17 Nov 2022 11:27:01 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     John Fastabend <john.fastabend@gmail.com>,
        Stanislav Fomichev <sdf@google.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     Martin KaFai Lau <martin.lau@linux.dev>, bpf@vger.kernel.org,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        song@kernel.org, yhs@fb.com, kpsingh@kernel.org, haoluo@google.com,
        jolsa@kernel.org, David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org
Subject: Re: [xdp-hints] Re: [PATCH bpf-next 05/11] veth: Support rx
 timestamp metadata for xdp
In-Reply-To: <637576962dada_8cd03208b0@john.notmuch>
References: <20221115030210.3159213-1-sdf@google.com>
 <20221115030210.3159213-6-sdf@google.com> <87h6z0i449.fsf@toke.dk>
 <CAKH8qBsEGD3L0XAVzVHcTW6k_RhEt74pfXrPLANuznSAJw7bEg@mail.gmail.com>
 <8735ajet05.fsf@toke.dk>
 <CAKH8qBsg4aoFuiajuXmRN3VPKYVJZ-Z5wGzBy9pH3pV5RKCDzQ@mail.gmail.com>
 <6374854883b22_5d64b208e3@john.notmuch>
 <34f89a95-a79e-751c-fdd2-93889420bf96@linux.dev> <878rkbjjnp.fsf@toke.dk>
 <6375340a6c284_66f16208aa@john.notmuch>
 <CAKH8qBs1rYXf0GGto9hPz-ELLZ9c692cFnKC9JLwAq5b7JRK-A@mail.gmail.com>
 <637576962dada_8cd03208b0@john.notmuch>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 17 Nov 2022 11:27:01 +0100
Message-ID: <87zgcp511m.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Just a separate comment on this bit:

John Fastabend <john.fastabend@gmail.com> writes:
> If you go with in-kernel BPF kfunc approach (vs user space side) I think
> you also need to add CO-RE to be friendly for driver developers? Otherwise
> they have to keep that read in sync with the descriptors?

CO-RE is for doing relocations of field offsets without having to
recompile. That's not really relevant for the kernel, that gets
recompiled whenever the layout changes. So the field offsets are just
kept in sync with offsetof(), like in Stanislav's RFCv2 where he had
this snippet:

+			/*	return ((struct sk_buff *)r5)->tstamp; */
+			BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_5,
+				    offsetof(struct sk_buff, tstamp)),

So I definitely don't think this is an argument against the kfunc
approach?

> Also need to handle versioning of descriptors where depending on
> specific options and firmware and chip being enabled the descriptor
> might be moving around.

This is exactly the kind of thing the driver is supposed to take care
of; it knows the hardware configuration and can pick the right
descriptor format. Either by just picking an entirely different kfunc
unroll depending on the config (if it's static), or by adding the right
checks to the unroll. You'd have to replicate all this logic in BPF
anyway, and while I'm not doubting *you* are capable of doing this, I
don't think we should be forcing every XDP developer to deal with all
this.

Or to put it another way, a proper hardware abstraction and high-quality
drivers is one of the main selling points of XDP over DPDK and other
kernel bypass solutions; we should not jettison this when enabling
metadata support!

-Toke

