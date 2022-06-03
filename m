Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F10EF53D3CE
	for <lists+netdev@lfdr.de>; Sat,  4 Jun 2022 01:15:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349617AbiFCXPF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jun 2022 19:15:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349610AbiFCXPF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jun 2022 19:15:05 -0400
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A02B33883
        for <netdev@vger.kernel.org>; Fri,  3 Jun 2022 16:15:03 -0700 (PDT)
Received: by mail-yb1-xb30.google.com with SMTP id w2so16266155ybi.7
        for <netdev@vger.kernel.org>; Fri, 03 Jun 2022 16:15:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=V83cVOVWbfZOQsiOP6Rw6DiCk8oeXmGbfnal2vl7lbI=;
        b=R/Ug6w6iwXnuTYOur6ggToT8cGH/aR8kC4da2RF87UTDSK18uY3G2hUaOgpo46qi6P
         sH3/1vTzcc+V0StsoZ8o784gxkF90ZRSMQk7AaFImUiLnijorsCBpYexzUEr07uklhD/
         O8Ioliovwssj89Q65+auD3Wm4xs4P+FMLx9dXblolyxVIqtWb+HO9uMHSBBFxYWUoUht
         hzcJgxZI4zpc8Z++QlWg/9k2kz8+Q/mZg77//q6PkQBGrbDNbip6y36sGM5T47kVCuvB
         k1bmh5G5qXzDBsKCllUH85XQSD1DR5KQgVqqtUqbfYK94sKAt0SrQvJ997H1yGqg/e0l
         2PUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=V83cVOVWbfZOQsiOP6Rw6DiCk8oeXmGbfnal2vl7lbI=;
        b=aKof1MqrW6ydORTAjs7aaSllr91K6hLKuGi4YJMeI548FBVr6qBGTyyHbuvOS7vymn
         w+SUDfoO0lVff39vz1EfxtzKnaMD2IHVsq8UgH88Z7M6uJGX4lEEXf58qCmhyBn0C8af
         nDUCM9YuQFyWG4lOn5aXhpHpDhjN3Tn1aZUjNhkVbjapYPCt4CMXDtXkEoESgq02hey0
         AugxKkXIlqENcZ53vWWyxqR1yLmnb2tF6pT8LYH8LwSs9fB3LqUi9Wn88u7twREUAMES
         v7ItRhixZsL1vdHIgl30Spts4GcCunOD1O/q4N+HgOzhTLoJ7214UUUjfCmvj2FPSRYB
         Q/kg==
X-Gm-Message-State: AOAM532HuEi+KQjqdg7qj31Jqo9Svdt3O7ceQZuqwNw8LaaFPCXzlQEA
        vttiOK4DowVp202P7aaZN7LOuoySiILtM4Zj0PfqsGyhPXjiNgR9
X-Google-Smtp-Source: ABdhPJya9KyFMLTzIg+TPURPxmZ2D0++lJnNXfY2GwA+bxZuqNS5DKePhgVHIH0jOMhYikrwmSiOAMw3WzbQmYW0cJM=
X-Received: by 2002:a05:6902:1548:b0:65e:a5d6:186b with SMTP id
 r8-20020a056902154800b0065ea5d6186bmr13151458ybu.55.1654298102368; Fri, 03
 Jun 2022 16:15:02 -0700 (PDT)
MIME-Version: 1.0
References: <MWHPR2201MB10728AE0EB8C691B5CDA6D7DD0A19@MWHPR2201MB1072.namprd22.prod.outlook.com>
In-Reply-To: <MWHPR2201MB10728AE0EB8C691B5CDA6D7DD0A19@MWHPR2201MB1072.namprd22.prod.outlook.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 3 Jun 2022 16:14:51 -0700
Message-ID: <CANn89iJXcDL6mMEkQdp8=KxYE5iZwPbN+458M4NF4m=hA1XzUg@mail.gmail.com>
Subject: Re: [BUG] Potential net namespace information leakage in /proc/net/sockstat
To:     "Liu, Congyu" <liu3101@purdue.edu>
Cc:     "ebiederm@xmission.com" <ebiederm@xmission.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 3, 2022 at 3:53 PM Liu, Congyu <liu3101@purdue.edu> wrote:
>
> Hi,
>
> In our test conducted on namespace, we found net information leakage in /=
proc/net/sockstat. For instance, the TCP "alloc" field exposes a TCP socket=
 related counter that is shared across all net namespaces on the same host.=
 Is this an intentional design for specific purposes?
>

These counters are global to the host, not per netns.
Note that /proc/slabinfo can somewhat 'reveal' similar information.

I guess nobody cared enough yet.

Something more concerning is the fact that one netns can steal all
tcp_mem memory.
