Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16B501154DA
	for <lists+netdev@lfdr.de>; Fri,  6 Dec 2019 17:09:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726480AbfLFQJm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Dec 2019 11:09:42 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:42474 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726371AbfLFQJm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Dec 2019 11:09:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575648580;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0Jg46z79WbtpUiP67474Qtl5e+X8n+Hw5qvI5wiIAV8=;
        b=L0UYYa5FdLcYHYY5tuXLP7jOnc9dHBVt6C/OienmQa/qlpiUVJdgXoYndbJenaHaqGSJxE
        7dEzVjaJLAOCiHkP5m+N4BFbqU/k0rOJ216mX32+8hICZeAnph8X/RExYM60Fae26cwmmP
        88U7J7BWqo6IZBHVK0Da8dJl9AO3wa0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-225-0LKdRZs3OiGykGWfDKQFvg-1; Fri, 06 Dec 2019 11:09:39 -0500
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4B5F6190D347;
        Fri,  6 Dec 2019 16:09:38 +0000 (UTC)
Received: from ovpn-117-234.ams2.redhat.com (ovpn-117-234.ams2.redhat.com [10.36.117.234])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B14C810016EB;
        Fri,  6 Dec 2019 16:09:36 +0000 (UTC)
Message-ID: <8b8a3cc1c3341912e0db5c55cd0e504dd4371588.camel@redhat.com>
Subject: Re: recvfrom/recvmsg performance and CONFIG_HARDENED_USERCOPY
From:   Paolo Abeni <pabeni@redhat.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        David Laight <David.Laight@ACULAB.COM>,
        network dev <netdev@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date:   Fri, 06 Dec 2019 17:09:35 +0100
In-Reply-To: <dc10298d-4280-b9b4-9203-be4000e85c42@gmail.com>
References: <23db23416d3148fa86e54dccc6152266@AcuMS.aculab.com>
         <dc10298d-4280-b9b4-9203-be4000e85c42@gmail.com>
User-Agent: Evolution 3.32.5 (3.32.5-1.fc30)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-MC-Unique: 0LKdRZs3OiGykGWfDKQFvg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2019-12-06 at 06:21 -0800, Eric Dumazet wrote:
> 
> On 12/6/19 5:39 AM, David Laight wrote:
> > Some tests I've done seem to show that recvmsg() is much slower that recvfrom()
> > even though most of what they do is the same.
> 
> Not really.
> 
> > One thought is that the difference is all the extra copy_from_user() needed by
> > recvmsg. CONFIG_HARDENED_USERCOPY can add a significant cost.
> > 
> > I've built rebuilt my 5.4-rc7 kernel with all the copy_to/from_user() in net/socket.c
> > replaced with the '_' prefixed versions (that don't call check_object()).
> > And also changed rw_copy_check_uvector() in fs/read_write.c.
> > 
> > Schedviz then showed the time spent by the application thread that calls
> > recvmsg() (about) 225 times being reduced from 0.9ms to 0.75ms.
> > 
> > I've now instrumented the actual recv calls. It show some differences,
> > but now enough to explain the 20% difference above.
> > (This is all made more difficult because my Ivy Bridge i7-3770 refuses
> > to run at a fixed frequency.)
> > 
> > Anyway using PERF_COUNT_HW_CPU_CYCLES I've got the following
> > histograms for the number of cycles in each recv call.
> > There are about the same number (2.8M) in each column over
> > an elapsed time of 20 seconds.
> > There are 450 active UDP sockets, each receives 1 message every 20ms.
> > Every 10ms a RT thread that is pinned to a cpu reads all the pending messages.
> > This is a 4 core hyperthreading (8 cpu) system.
> > During these tests 5 other threads are also busy.
> > There are no sends (on those sockets).
> > 
> >          |       recvfrom      |       recvmsg
> >  cycles  |   unhard  |    hard |   unhard  |    hard
> > -----------------------------------------------------
> >    1472:         29          1          0          0
> >    1600:       8980       4887          3          0
> >    1728:     112540     159518       5393       2895
> >    1856:     174555     270148     119054     111230
> >    1984:     126007     168383     152310     195288
> >    2112:      80249      87045     118941     168801
> >    2240:      61570      54790      81847     110561
> >    2368:      95088      61796      57496      71732
> >    2496:     193633     155870      54020      54801
> >    2624:     274997     284921     102465      74626
> >    2752:     276661     295715     160492     119498
> >    2880:     248751     264174     206327     186028
> >    3008:     207532     213067     230704     229232
> >    3136:     167976     164804     226493     238555
> >    3264:     133708     124857     202639     220574
> >    3392:     107859      95696     172949     189475
> >    3520:      88599      75943     141056     153524
> >    3648:      74290      61586     115873     120994
> >    3776:      62253      50891      96061      95040
> >    3904:      52213      42482      81113      76577
> >    4032:      42920      34632      69077      63131
> >    4160:      35472      28327      60074      53631
> >    4288:      28787      22603      51345      46620
> >    4416:      24072      18496      44006      40325
> >    4544:      20107      14886      37185      34516
> >    4672:      16759      12206      31408      29031
> >    4800:      14195       9991      26843      24396
> >    4928:      12356       8167      22775      20165
> >    5056:      10387       6931      19404      16591
> >    5184:       9284       5916      16817      13743
> >    5312:       7994       5116      14737      11452
> >    5440:       7152       4495      12592       9607
> >    5568:       6300       3969      11117       8592
> >    5696:       5445       3421       9988       7237
> >    5824:       4683       2829       8839       6368
> >    5952:       3959       2643       7652       5652
> >    6080:       3454       2377       6442       4814
> >    6208:       3041       2219       5735       4170
> >    6336:       2840       2060       5059       3615
> >    6464:       2428       1975       4433       3201
> >    6592:       2109       1794       4078       2823
> >    6720:       1871       1382       3549       2558
> >    6848:       1706       1262       3110       2328
> >    6976:       1567       1001       2733       1991
> >    7104:       1436        873       2436       1819
> >    7232:       1417        860       2102       1652
> >    7360:       1414        741       1823       1429
> >    7488:       1372        814       1663       1239
> >    7616:       1201        896       1430       1152
> >    7744:       1275       1008       1364       1049
> >    7872:       1382       1120       1367        925
> >    8000:       1316       1282       1253        815
> >    8128:       1264       1266       1313        792
> >   8256+:      19252      19450      34703      30228
> > ----------------------------------------------------
> >   Total:    2847707    2863582    2853688    2877088
> > 
> > This does show a few interesting things:
> > 1) The 'hardened' kernel is slower, especially for recvmsg.
> > 2) The difference for recvfrom isn't enough for the 20% reduction I saw.
> > 3) There are two peaks at the top a 'not insubstantial' number are a lot
> >    faster than the main peak.
> > 4) There is second peak way down at 8000 cycles.
> >    This is repeatable.
> > 
> > Any idea what is actually going on??
> > 
> 
> Real question is : Do you actually need to use recvmsg() instead of recvfrom() ?
> 
> If recvmsg() provides additional cmsg, this is not surprising it is more expensive.
> 
> recvmsg() also uses an indirect call, so CONFIG_RETPOLINE=y is probably hurting.
> 
> err = (nosec ? sock_recvmsg_nosec : sock_recvmsg)(sock, msg_sys, flags);
> 
> Maybe a INDIRECT_CALL annotation could help, or rewriting this to not let gcc
> use an indirect call.
> 
> 
> diff --git a/net/socket.c b/net/socket.c
> index ea28cbb9e2e7a7180ee63de2d09a81aacb001ab7..752714281026dab6db850ec7fa75b7aa6240661f 100644
> --- a/net/socket.c
> +++ b/net/socket.c
> @@ -2559,7 +2559,10 @@ static int ____sys_recvmsg(struct socket *sock, struct msghdr *msg_sys,
>  
>         if (sock->file->f_flags & O_NONBLOCK)
>                 flags |= MSG_DONTWAIT;
> -       err = (nosec ? sock_recvmsg_nosec : sock_recvmsg)(sock, msg_sys, flags);
> +       if (nosec)
> +               err = sock_recvmsg_nosec(sock, msg_sys, flags);
> +       else
> +               err = sock_recvmsg(sock, msg_sys, flags);
>         if (err < 0)
>                 goto out;
>         len = err;

Oh, nice! I though the compiler was smart enough to avoid the indirect
call with the current code, but it looks like that least gcc 9.2.1 is
not.

Thanks for pointing that out!

In this specific scenario I think the code you propose above is better
than INDIRECT_CALL.

Would you submit the patch formally?

Thank you!

Paolo

