Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75D1061481B
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 12:00:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230058AbiKALAn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 07:00:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230057AbiKALAc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 07:00:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13CF318B1C;
        Tue,  1 Nov 2022 04:00:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A74E7615B7;
        Tue,  1 Nov 2022 11:00:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE9ADC433D7;
        Tue,  1 Nov 2022 11:00:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667300430;
        bh=Kj1eE4Y197ou0E8+vB3UV8meREwlWjE+4YDIl8CuQhU=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=MO8PR9MVgAOzqOcK6/OciwNYrU2zaC+1PiT2tvIWdsH5I0U8nOJDpczs5BtdYDnlA
         9IqOLs3k3ZGWZNLusOm/DI1U7s26PbmjXa3s3zOgO+9RVjG0dwmuJq6+9uOED1sEuQ
         sSDwA10ffYZ9N/Ttv0ne4iZW+SYZ+vU/tNvJ1Qscq4cdGdXn7dR8tRzi/VLq3O4M2b
         b1UwAlNQz6b4k5hl2TYGIOAZgnxaLdIR3s6Vj6PJo5VCK/Q/lYhMfFmm9BJtHnN3W5
         PVXDkf1m/ScOEyqrv6RvLeNYQDCIPBdoCA+VvpJOwVdRbop/WtR4xEVirM515QB4nN
         SrxDU34wIFtBw==
From:   =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>
To:     Jiri Olsa <olsajiri@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Cc:     Jiri Olsa <olsajiri@gmail.com>,
        David Laight <David.Laight@aculab.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        bpf@vger.kernel.org
Subject: Re: Linux 6.1-rc3 build fail in include/linux/bpf.h
In-Reply-To: <Y2BD6xZ108lv3j7J@krava>
References: <439d8dc735bb4858875377df67f1b29a@AcuMS.aculab.com>
 <Y1+8zIdf8mgQXwHg@krava>
 <Y1/oBlK0yFk5c/Im@hirez.programming.kicks-ass.net>
 <Y2BD6xZ108lv3j7J@krava>
Date:   Tue, 01 Nov 2022 12:00:27 +0100
Message-ID: <87wn8fszw4.fsf@all.your.base.are.belong.to.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jiri Olsa <olsajiri@gmail.com> writes:

> On Mon, Oct 31, 2022 at 04:21:42PM +0100, Peter Zijlstra wrote:
>>=20
>> Does something crazy like the below work? It compiles but is otherwise
>> totally untested.
>
> looks good
>
> it has now the ftrace nop and the jump to the dispatcher image
> or the bpf_dispatcher_nop_func.. great :)
>
> 	bpf_dispatcher_xdp_func:
>
> 	ffffffff81cc87b0 <load1+0xcc87b0>:
> 	ffffffff81cc87b0:       0f 1f 44 00 00          nopl   0x0(%rax,%rax,1)
> 	ffffffff81cc87b5:       e9 a6 fe 65 ff          jmp    0xffffffff81328660
>
> tests work for me..  Toke, Bj=C3=B6rn, could you please check?

Awesome! Much nicer!=20

For Peter's patch, feel free to add:
Acked-by: Bj=C3=B6rn T=C3=B6pel <bjorn@kernel.org>
