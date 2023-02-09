Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8612368FC69
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 02:08:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231149AbjBIBIy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 20:08:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230487AbjBIBIy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 20:08:54 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A4099ED6;
        Wed,  8 Feb 2023 17:08:53 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id n20-20020a17090aab9400b00229ca6a4636so4605117pjq.0;
        Wed, 08 Feb 2023 17:08:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=aeYFdVMeaGXZ8pQboFFMn+nx5SREQ527KN43sqYMZK4=;
        b=m5qVYRU6vrrvo3NCP1kIhk82cUP8n1q+wscOOGZ3Nfs+BH1TzSokfpoFyz7E0llJIA
         elebF+cIMLkX4iASQm6US6FGFeK2eb967qwsEuc6dK+SliWi+3mVW7iNnIsQ8ps5T6Cj
         wooz9gfrvTvIcdOe+VN1eFXF0LrDpvAJH62ZxRIADFWqMfRAMFGWorIAUmIlhJMazU53
         TNRbW+lPDu7Pmr+6HjfwqtrrumxoQuhTSHkGpAu41pIGW84aiZa+ylKWYPH5oeZVYwj/
         J1AllVYSAPExNzjWfNc85MJSUrPWoJcaAqIsJqxf/64ofhZGS9V+CbzrW3J5ePkXNDQa
         HkAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aeYFdVMeaGXZ8pQboFFMn+nx5SREQ527KN43sqYMZK4=;
        b=MZIGTNuJyIw5n1XkwyMdUNjBLIY1n/IyI56OYGwWW+6wDaGqg9MMpKXp+Pn2/l3eGr
         OriIwbtckoREcqjIqZOb9mU13C8jwPLqp6NjtH6Ycfbgj4mW57dXpBN5NBLMKPahCAtt
         0eT4DM3rU085rfW6z98LVB50D+UDmYF+k/Jn1itvdk/L9OUGL/V36G3yelDAKa49fkFa
         RvO+FAHM2L7qfdiQweiWKSHA5fS984taho6w2q1fQYhF30fBdl7D4mATFJvrtQJG/d/O
         L2ZX6Z9tWI96FqVjBet2DwXyW0J3gG1jODOcAa4iSqWpn9DmGrHuEWKckW/NMcf3lDta
         9uDQ==
X-Gm-Message-State: AO0yUKWEoDWm0BfvIluKay6Z52yq6R3jsWdxq+TkPoMyY/aXA+qLLdsH
        B4Y8fQQQ9jMYGKJjgASb+tvbLw+x0C4swk5kkaM=
X-Google-Smtp-Source: AK7set/L/4PK5i4Nk/tyPcro29I7KmIGdPeypqvLUROocj5T/PUnxi+fk2QbitZqJPpg97x6sOnqA/3zjYpVYE3ZEg4=
X-Received: by 2002:a17:90a:3f10:b0:22c:1179:3b8f with SMTP id
 l16-20020a17090a3f1000b0022c11793b8fmr1157190pjc.118.1675904932512; Wed, 08
 Feb 2023 17:08:52 -0800 (PST)
MIME-Version: 1.0
References: <20230204133535.99921-1-kerneljasonxing@gmail.com>
 <20230204133535.99921-4-kerneljasonxing@gmail.com> <CAL+tcoD9nE-Ad7+XoshoQ8qp7C0H+McKX=F6xt2+UF1BeWXKbg@mail.gmail.com>
In-Reply-To: <CAL+tcoD9nE-Ad7+XoshoQ8qp7C0H+McKX=F6xt2+UF1BeWXKbg@mail.gmail.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Wed, 8 Feb 2023 17:08:41 -0800
Message-ID: <CAKgT0Uc7d5iomJnrvPdngt6u9ns7S1ismhH_C2R1YWarg04wWg@mail.gmail.com>
Subject: Re: [PATCH net 3/3] ixgbe: add double of VLAN header when computing
 the max MTU
To:     Jason Xing <kerneljasonxing@gmail.com>
Cc:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, richardcochran@gmail.com, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        alexandr.lobakin@intel.com, maciej.fijalkowski@intel.com,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        Jason Xing <kernelxing@tencent.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 8, 2023 at 4:47 PM Jason Xing <kerneljasonxing@gmail.com> wrote:
>
> CC Alexander Duyck
>
> Hello Alexander, thanks for reviewing the other two patches of this
> patchset last night. Would you mind reviewing the last one? :)
>
> Thanks,
> Jason

It looks like this patch isn't in the patch queue at:
https://patchwork.kernel.org/project/netdevbpf/list/

I believe you will need to resubmit it to get it accepted upstream.

The patch itself looks fine. Feel free to add my reviewed by when you submit it.

Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
