Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 613AF4D220D
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 20:54:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345500AbiCHTys (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 14:54:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235196AbiCHTys (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 14:54:48 -0500
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F00049F09
        for <netdev@vger.kernel.org>; Tue,  8 Mar 2022 11:53:51 -0800 (PST)
Received: by mail-yb1-xb30.google.com with SMTP id g26so39902720ybj.10
        for <netdev@vger.kernel.org>; Tue, 08 Mar 2022 11:53:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4wTTz8ZXhShueL+d5PTkPe5oHWQmfzMgiAzN5z6Rr+M=;
        b=l6xeFM9bowlni/gpVmFZkeZAZRHRnZlX07CKSTl4oZ8AUjoL3uyQV8CRTerCh+qM4Q
         s13/JRpFCmqEe+zeFiXDhXet5+NgPZ/54zzQJrdvd89bkBoiog8hC3jMcdEKOzrRzPVU
         KfI5tzpU4TWmZRcAk5/OaDtqOE+WgEyTU4uDjvZU/pNNU1qbuF63iw01fujBOFOKYLQ9
         IGvXDVXvSeJLa8epYN0wdOztf+gDQPPP7POw+QZ1h74P3mS7oyUEQ4Bm8AymjOWhBB77
         0vCf+nIuMlSOCIN94J591bsdHZqOMhm1yU+fPWhg+zA/xD2Y8MVKMERR+tJUC1AL+oa8
         fHww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4wTTz8ZXhShueL+d5PTkPe5oHWQmfzMgiAzN5z6Rr+M=;
        b=NXEQoZ8bW8KWCU3CJG9vixPuAildjOEEmDuy2MEbWxP6M9kRjeAvm7tu4DcRa483YU
         xiVMeIyPBjXUCaP76lud7bxg7sssbWIti3x5EqERTT26e/4SGGpY/rObrirpEs2K8WOZ
         Ix7Se8WkTdmgVkW8GzLSGq3S6Y4pEUOviCTHHGrBYbts004BuFI7O+I5nitJhEF2sVMG
         /LQb8XypbDeccusTpfRSU2QYgjP+L3KKTQOfThCeuwvYN8lavJlJGdHzx5aoBV0L4OOc
         jdGqfm2ES3xeMwLSPUlYO59uqrollk4SWEvKWbq17eW2TX081d4vxcRrjaaQIkeIvJwU
         bA+g==
X-Gm-Message-State: AOAM531fVID5RTT2DtV/W160z8pliiW3aINmNncZS0CUnYAffffcd2FD
        RQYgdpnyJzunm4Bc22UK1MnImHaZUs5Yj/jMMNm2Rk668u1IxPqX
X-Google-Smtp-Source: ABdhPJx+uTcQgkQq27AK9B7ARoAooIH07EDUdqZVpXRo8MGtxwdUV7nBc5PDDKAx8t2mO1pmTWXMiDuE+KV3YQ8J7Bk=
X-Received: by 2002:a05:6902:1347:b0:629:1863:9dc6 with SMTP id
 g7-20020a056902134700b0062918639dc6mr13434070ybu.36.1646769229975; Tue, 08
 Mar 2022 11:53:49 -0800 (PST)
MIME-Version: 1.0
References: <20220308030348.258934-1-kuba@kernel.org> <CANn89iLoWOdLQWB0PeTtbOtzkAT=cWgzy5_RXqqLchZu1GziZw@mail.gmail.com>
 <652afb8e99a34afc86bd4d850c1338e5@AcuMS.aculab.com>
In-Reply-To: <652afb8e99a34afc86bd4d850c1338e5@AcuMS.aculab.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 8 Mar 2022 11:53:38 -0800
Message-ID: <CANn89iL0XWF8aavPFnTrRazV9T5fZtn3xJXrEb07HTdrM=rykw@mail.gmail.com>
Subject: Re: [RFC net-next] tcp: allow larger TSO to be built under overload
To:     David Laight <David.Laight@aculab.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev <netdev@vger.kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>
Content-Type: text/plain; charset="UTF-8"
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

On Tue, Mar 8, 2022 at 1:08 AM David Laight <David.Laight@aculab.com> wrote:
>
> From: Eric Dumazet
> > Sent: 08 March 2022 03:50
> ...
> >         /* Goal is to send at least one packet per ms,
> >          * not one big TSO packet every 100 ms.
> >          * This preserves ACK clocking and is consistent
> >          * with tcp_tso_should_defer() heuristic.
> >          */
> > -       segs = max_t(u32, bytes / mss_now, min_tso_segs);
> > -
> > -       return segs;
> > +       return max_t(u32, bytes / mss_now, min_tso_segs);
> >  }
>
> Which is the common side of that max_t() ?
> If it is mon_tso_segs it might be worth avoiding the
> divide by coding as:
>
>         return bytes > mss_now * min_tso_segs ? bytes / mss_now : min_tso_segs;
>

I think the common case is when the divide must happen.
Not sure if this really matters with current cpus.

Jakub, Neal, I am going to send a patch for net-next.

In conjunction with BIG TCP, this gives a considerable boost of performance.


Before:
otrv5:/home/google/edumazet# nstat -n;./super_netperf 600 -H otrv6 -l
20 -- -K dctcp -q 20000000;nstat|egrep
"TcpInSegs|TcpOutSegs|TcpRetransSegs|Delivered"
  96005
TcpInSegs                       15649381           0.0
TcpOutSegs                      58659574           0.0  # Average of
3.74 4K segments per TSO packet
TcpExtTCPDelivered              58655240           0.0
TcpExtTCPDeliveredCE            21                 0.0

After:
otrv5:/home/google/edumazet# nstat -n;./super_netperf 600 -H otrv6 -l
20 -- -K dctcp -q 20000000;nstat|egrep
"TcpInSegs|TcpOutSegs|TcpRetransSegs|Delivered"
  96046
TcpInSegs                       1445864            0.0
TcpOutSegs                      58885065           0.0   # Average of
40.72 4K segments per TSO packet
TcpExtTCPDelivered              58880873           0.0
TcpExtTCPDeliveredCE            28                 0.0

-> 1,445,864 ACK packets instead of 15,649,381
And about 25 % of cpu cycles saved, according to perf stat

 Performance counter stats for './super_netperf 600 -H otrv6 -l 20 --
-K dctcp -q 20000000':

         66,895.00 msec task-clock                #    2.886 CPUs
utilized
         1,312,687      context-switches          # 19623.389 M/sec
             5,645      cpu-migrations            #   84.387 M/sec
           942,412      page-faults               # 14088.139 M/sec
   203,672,224,410      cycles                    # 3044700.936 GHz
               (83.40%)
    18,933,350,691      stalled-cycles-frontend   #    9.30% frontend
cycles idle     (83.46%)
   138,500,001,318      stalled-cycles-backend    #   68.00% backend
cycles idle      (83.38%)
    53,694,300,814      instructions              #    0.26  insn per
cycle
                                                  #    2.58  stalled
cycles per insn  (83.30%)
     9,100,155,390      branches                  # 136038439.770
M/sec               (83.26%)
       152,331,123      branch-misses             #    1.67% of all
branches          (83.47%)

      23.180309488 seconds time elapsed

-->

 Performance counter stats for './super_netperf 600 -H otrv6 -l 20 --
-K dctcp -q 20000000':

         48,964.30 msec task-clock                #    2.103 CPUs
utilized
           184,903      context-switches          # 3776.305 M/sec
             3,057      cpu-migrations            #   62.434 M/sec
           940,615      page-faults               # 19210.338 M/sec
   152,390,738,065      cycles                    # 3112301.652 GHz
               (83.61%)
    11,603,675,527      stalled-cycles-frontend   #    7.61% frontend
cycles idle     (83.49%)
   120,240,493,440      stalled-cycles-backend    #   78.90% backend
cycles idle      (83.30%)
    37,106,498,492      instructions              #    0.24  insn per
cycle
                                                  #    3.24  stalled
cycles per insn  (83.47%)
     5,968,256,846      branches                  # 121890712.483
M/sec               (83.25%)
        88,743,145      branch-misses             #    1.49% of all
branches          (83.24%)

      23.284583305 seconds time elapsed
