Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE5074EB90C
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 05:48:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242415AbiC3Dt7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Mar 2022 23:49:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241098AbiC3Dt6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Mar 2022 23:49:58 -0400
Received: from mail-yw1-x112f.google.com (mail-yw1-x112f.google.com [IPv6:2607:f8b0:4864:20::112f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77324B82
        for <netdev@vger.kernel.org>; Tue, 29 Mar 2022 20:48:14 -0700 (PDT)
Received: by mail-yw1-x112f.google.com with SMTP id 00721157ae682-2e5827a76f4so204589897b3.6
        for <netdev@vger.kernel.org>; Tue, 29 Mar 2022 20:48:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OLJhu1X5FtoQkwHn6+oh/mMllWrHxAekfRIfQBt2vdU=;
        b=eoJh77BxtbynP4AkXAv2COxjAUwLCayLNehSxMrAC80VGyDfodWC6PqB3mduSktWQw
         luB/XUQxChj5dMkxweIz9+O5P+qjrUcmdN9jILUkCkEXTEzIrNXX2kWkp2sHZ/pixNcD
         IpPmdDSM2L989f+igazLU+YN4mDLmhECsxjxN5ZoH3MVf7NGTQwAA8oRKqzjXqt5tp1q
         LzJnDL4R/hJOG+IYRs0sSVzKyVvmmtvEoSS+kJt/cm6Zb7DB2vsN1O/BhbCz/o2cVQM5
         2AN+gyz/93tpgEgCuPlJUgDhbsN0vE2aicuF8q+gIhoD1/wDyUmsOb46PtKqlGa0/S3W
         /q3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OLJhu1X5FtoQkwHn6+oh/mMllWrHxAekfRIfQBt2vdU=;
        b=evWJ9VUVnCbc/kpO3guTpXFjTP6U/+bvNrCtkl03f7NNxD1fNi/kA7jYJQSdg41a05
         f/pkYvWOmZpfjs1mCHAMCG8lvL6jyWhco3Xf6PQ9OclyDpucobHSN2n8rKv8PaqQyMqR
         5D7DxWrOifm44DpAQpU6ivcqkE4Oc4OAF5eK3+aSTvDSIxyhQ9lzFaJ2DtD44XdMXSoK
         41/McXNu8llKnwBnWG4JsklmGUJuVz616vyYQ0lZo6NwwVrSNEOC+0Uvwc9eif5TNeJy
         7HeuS6myNQYUHEztDT05lazlKZBeqYriJk/gzmGw4H8OUIkeirtygE2/iUjKktWDleH+
         GrfQ==
X-Gm-Message-State: AOAM531t5NxjHaTMpIPIQ3rXgVOP9qrRPHfdJBdbsULLjm6hRL/eHIsx
        JAhVT4O37c8oxn32mgiA/ABwvi0OuWS2lWcndQr/8g==
X-Google-Smtp-Source: ABdhPJzUK1dnT4fhGNhf0xAhwoBubVCTiyRw90BHPhcENfOcoWZmyERNv82c3rWyYBb+/UGbza+R0/za9HNU4r+kk2I=
X-Received: by 2002:a81:1693:0:b0:2e5:874a:c060 with SMTP id
 141-20020a811693000000b002e5874ac060mr34180512yww.489.1648612093325; Tue, 29
 Mar 2022 20:48:13 -0700 (PDT)
MIME-Version: 1.0
References: <E1nZMdl-0006nG-0J@plastiekpoot> <CADVnQyn=A9EuTwxe-Bd9qgD24PLQ02YQy0_b7YWZj4_rqhWRVA@mail.gmail.com>
 <eaf54cab-f852-1499-95e2-958af8be7085@uls.co.za>
In-Reply-To: <eaf54cab-f852-1499-95e2-958af8be7085@uls.co.za>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 29 Mar 2022 20:48:02 -0700
Message-ID: <CANn89iKHbmVYoBdo2pCQWTzB4eFBjqAMdFbqL5EKSFqgg3uAJQ@mail.gmail.com>
Subject: Re: linux 5.17.1 disregarding ACK values resulting in stalled TCP connections
To:     Jaco Kroon <jaco@uls.co.za>
Cc:     Neal Cardwell <ncardwell@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Yuchung Cheng <ycheng@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 29, 2022 at 7:58 PM Jaco Kroon <jaco@uls.co.za> wrote:
>
> Hi Neal,
>
> > Thanks for the report!  I have CC-ed the netdev list, since it is
> > probably a better forum for this discussion.
> Awesome thank you.
> >
> > Can you please attach (or link to) a tcpdump raw .pcap file  (produced
> > with the -w flag)? There are a number of tools that will make this
> > easier to visualize and analyze if we can see the raw .pcap file. You
> > may want to anonymize the trace and/or capture just headers, etc (for
> > example, the -s flag can control how much of each packet tcpdump
> > grabs).
>
> Attached.
>
> The traffic itself should be mostly encrypted but stripped with -s100
> anyway.  At this point SACK was still on.
>
> I don't know how, or why, but this relates to TFO.  After sending report
> on a hunch (based on comparing the exim logs of a successful delivery
> compared to a non-successful) and the only difference was that the
> non-working was stating:
>
> TFO mode sendto, no data: EINPROGRESS
>
> and then specifically:
>
> TCP_FASTOPEN tcpi_unacked 2
>
> The working connections never had the latter line in the output.
>
> The moment I set sysctl -w net.ipv4.tcp_fastopen=0 (default is 1) I've
> managed to flood out about 1200 emails to google in a matter of no more
> than 15 minutes.
>
> In the kernel sources:  git log v5.8..v5.17 net/
>
> And searching for TFO only gives so many possible commits that broke
> this, just looking at changelogs I'm not sure if any of them are
> relevant.  I'm guessing the issue possibly relates to congestion
> control, as such this is probably the most relevant:
>
> commit be5d1b61a2ad28c7e57fe8bfa277373e8ecffcdc
> Author: Nguyen Dinh Phi <phind.uet@gmail.com>
> Date:   Tue Jul 6 07:19:12 2021 +0800
>
>     tcp: fix tcp_init_transfer() to not reset icsk_ca_initialized
>
> Just looking at the diff it removes a icsk->icsk_ca_initialized = 0; -
> the only other place this gets set to 0 is in tcp_disconnect() ... and
> to 1 in tcp_init_congestion_control() - so I think we might have an
> uninitialized variable here ... then again tcp_init_socket mentions
> explicitly that sk_alloc set lots of stuff to 0 - still bugs me that the
> original commit (8919a9b31eb4) felt the need to set an explicit 0 in
> tcp_init_transfer().

I do not think this commit is related to the issue you have.

I guess you could try a revert ?

Then, if you think old linux versions were ok, start a bisection ?

Thank you.

(I do not see why a successful TFO would lead to a freeze after ~70 KB
of data has been sent)

>
> >
> > Can you please share the exact kernel version of the client machine?
> Our side (client) is 5.17.1 (side that initiates TCP/IP connection), I
> obviously can't comment for the Google side (server).
> > Also, can you please summarize/clarify whether you think the client,
> > server, or both are misbehaving?
>
> client is re-transmitting frames for which it has already received an
> ACK from the server.  In pcap from frames 105 onwards one can start
> seeing retransmits, then first "spurious retransmission" as wireshark
> labels it from frames 122 onwards.
>
> Kind Regards,
> Jaco
