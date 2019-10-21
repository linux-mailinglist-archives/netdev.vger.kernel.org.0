Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27048DF561
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 20:51:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730142AbfJUSuJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 14:50:09 -0400
Received: from mail-lj1-f169.google.com ([209.85.208.169]:47093 "EHLO
        mail-lj1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730084AbfJUSuJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 14:50:09 -0400
Received: by mail-lj1-f169.google.com with SMTP id d1so14436038ljl.13
        for <netdev@vger.kernel.org>; Mon, 21 Oct 2019 11:50:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hXiuJzfcUb4Fraw8s4mIcy/tAIVzwrCRwqGymnuoNJo=;
        b=lxAdSztdSGaLxSiwenByb0w7TMWVT7kvo1xw2atuSt9Obs5OTG2FIjQWQUxm8CmBtL
         N37gvNCNfSpJj0sZgjKK0Y2uIxN/KL/wpfumehJAVJgFWCgQC/S5K4Fl75VnzfSuFe7d
         hKMM9egZzHvJCM7GPPypfwlyV1xU7pKbi0ZEu/JDMf8colp9bEUprBQzVwFBNMwkci6s
         cb+1Z37U0/TeMNXBPUvcyGp+IUIm20V8D1R3zoOjwZZOIJfCyGwOZi6MzsgU0W2CVdSJ
         ZSalYCgs1P6x0MomH8d7+Hg029zuurDCvhDTNx2kcC4WEe/COPIjsXZC6mwfZdPlqbLY
         si3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hXiuJzfcUb4Fraw8s4mIcy/tAIVzwrCRwqGymnuoNJo=;
        b=LHpnEYhXeCPRDZ/AfuySwwLNEN7D8ONIwHBQU2SAUnPoWape9eqpbqkeNYpwBJgGlx
         E+EsnECpnXW1/UlV55s6CUpAmbCdP3siJbrxpf2rUmxDUTjnjit4aDUeQLy5MPSmqpLg
         xqs6LP+hVF7HdWSFcj1tXdyCM2WHpXDUkdn7fwhCBEkzzRaRFLvtdk7Y2dgdwWQUmsRJ
         1L+cvufI8L9c8XPosT14oj9LxbnRcK31siNNTMkUOPrL+v97iXmz0oAYB3NpLpubSznb
         u4HNBCsEbhLGL7sHojoLVIcBtImvqBbtZ0qGOvIeaX77mX7w5bYQIndFrRJe48cKBEy/
         UWow==
X-Gm-Message-State: APjAAAXOjNlXQ8nUE8n3ETF3XonCXy+Ju5tprIRU1f6bZc1CiiH8WCFQ
        eJLiEyDKW3pBHSrjMh8rZ/tjjVMgr9Qkic+ewRivBKiP
X-Google-Smtp-Source: APXvYqx6fSh21dxcSx1SSpyE+pDf9Xj9RUL3zia0faOz1FLflx786CjRQnsp7XBxlul+PvyoQkj/ejZtMaNGWovQ648=
X-Received: by 2002:a2e:b17b:: with SMTP id a27mr15858192ljm.7.1571683807061;
 Mon, 21 Oct 2019 11:50:07 -0700 (PDT)
MIME-Version: 1.0
References: <1571425340-7082-1-git-send-email-jbaron@akamai.com>
In-Reply-To: <1571425340-7082-1-git-send-email-jbaron@akamai.com>
From:   William Dauchy <wdauchy@gmail.com>
Date:   Mon, 21 Oct 2019 20:49:54 +0200
Message-ID: <CAJ75kXa0EcXtn6xBNCr56A_Auzm9NOtPGhXUTGvSARKgfOjTcw@mail.gmail.com>
Subject: Re: [net-next] tcp: add TCP_INFO status for failed client TFO
To:     Jason Baron <jbaron@akamai.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        NETDEV <netdev@vger.kernel.org>,
        Neal Cardwell <ncardwell@google.com>,
        Christoph Paasch <cpaasch@apple.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Jason,

On Sat, Oct 19, 2019 at 11:10 AM Jason Baron <jbaron@akamai.com> wrote:
> The TCPI_OPT_SYN_DATA bit as part of tcpi_options currently reports whether
> or not data-in-SYN was ack'd on both the client and server side. We'd like
> to gather more information on the client-side in the failure case in order
> to indicate the reason for the failure. This can be useful for not only
> debugging TFO, but also for creating TFO socket policies. For example, if
> a middle box removes the TFO option or drops a data-in-SYN, we can
> can detect this case, and turn off TFO for these connections saving the
> extra retransmits.
>
> The newly added tcpi_fastopen_client_fail status is 2 bits and has 4
> states:
>
> 1) TFO_STATUS_UNSPEC
>
> catch-all.
>
> 2) TFO_NO_COOKIE_SENT
>
> If TFO_CLIENT_NO_COOKIE mode is off, this state indicates that no cookie
> was sent because we don't have one yet, its not in cache or black-holing
> may be enabled (already indicated by the global
> LINUX_MIB_TCPFASTOPENBLACKHOLE).
>
> 3) TFO_NO_SYN_DATA
>
> Data was sent with SYN, we received a SYN/ACK but it did not cover the data
> portion. Cookie is not accepted by server because the cookie may be invalid
> or the server may be overloaded.
>
>
> 4) TFO_NO_SYN_DATA_TIMEOUT
>
> Data was sent with SYN, we received a SYN/ACK which did not cover the data
> after at least 1 additional SYN was sent (without data). It may be the case
> that a middle-box is dropping data-in-SYN packets. Thus, it would be more
> efficient to not use TFO on this connection to avoid extra retransmits
> during connection establishment.
>
> These new fields certainly not cover all the cases where TFO may fail, but
> other failures, such as SYN/ACK + data being dropped, will result in the
> connection not becoming established. And a connection blackhole after
> session establishment shows up as a stalled connection.

I'm curious what would be the arguments compared to creating a new
getsockopt() to fetch this data?

Thanks,

-- 
William
