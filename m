Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58810DD59F
	for <lists+netdev@lfdr.de>; Sat, 19 Oct 2019 01:58:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390589AbfJRX6L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 19:58:11 -0400
Received: from mail-ot1-f42.google.com ([209.85.210.42]:42774 "EHLO
        mail-ot1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730521AbfJRX6K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 19:58:10 -0400
Received: by mail-ot1-f42.google.com with SMTP id c10so6386701otd.9
        for <netdev@vger.kernel.org>; Fri, 18 Oct 2019 16:58:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=x6SO+Ltceh29jig/aqwwvgoR5JbLnn9mt6leazediHo=;
        b=QQALchlu/VJeXNRWrAmSorgYtbGRQGh8fnbElKX3OB1tI85hAQHyOOZLjMfaHvFaoy
         HZh/N3/v5cZRMyXyZUXBlK+0Knbc0xj79CfORkGMRs4z7TVEnV1B0y49a1ismR4fGiOP
         qe+ZdV8THJ16Jtazsak4RRV56LZmqXIlx78SVIPzCD0/RJ/eK1qnIevbLhjROEMHQHUv
         8ehqaaYqWSgvKbyLWyNmDzuv6D3hEAGn9TrTFTSYEUwyf9ezy1EY037cK0eSWR0A52dJ
         96AwsD8Y3ijji8pGgM0CcW/Ii5aF/0Vde/1FsSwZKlS6X51tJCmM+cjXlRVtgvMndRQg
         DgPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=x6SO+Ltceh29jig/aqwwvgoR5JbLnn9mt6leazediHo=;
        b=ec/UxDxhp4sGb00FmUh5QYmae7b1jDh12li+WSjGWW2F772AvDPdIvdkyX8MvssM7B
         Qh44iaBVVJHC0XO7SL3WfSPucHgwdkvChBoe+Xsp3QqUa80u/qCZIJyl/shiTQQ5oYlm
         J6bo1x9zjeqD90nU2bnvsoUw2o3zcgPnlTFQLWdH0n4berEhpWxGlR8m27WKOaCglPEG
         ZHX8LLHvMUssxpy+0KmuCCWBmIJA/Wbg9gjqY70Os0MwXziol6E1sy1yjO8H98kZhdyp
         B69X1k56fOkp365tgf6asErUq0SYTi7M7YBWABtcOpUSYENyPhttRulinmRiC/+lXiBP
         D7Ng==
X-Gm-Message-State: APjAAAXIDiUIjqjy8bXQcMl8ZVgvC1vOPxYFTOT3ZOsfF+C5f6rDbJQW
        ulNXhsyHqFtS6BEsuw4QWXBojDaRUTTklYXo/UU+yw==
X-Google-Smtp-Source: APXvYqw8r6qChUJM5DtmqkoUAXRco3Zi9CdO51Pm0rWV0UTEHi6V+cN/gaWdZMrIgpVdRSK8YFOTY2K25Ve3eRkbs1U=
X-Received: by 2002:a9d:66d:: with SMTP id 100mr9691423otn.302.1571443089162;
 Fri, 18 Oct 2019 16:58:09 -0700 (PDT)
MIME-Version: 1.0
References: <1571425340-7082-1-git-send-email-jbaron@akamai.com>
In-Reply-To: <1571425340-7082-1-git-send-email-jbaron@akamai.com>
From:   Neal Cardwell <ncardwell@google.com>
Date:   Fri, 18 Oct 2019 19:57:53 -0400
Message-ID: <CADVnQymUMStN=oReEXGFT24NTUfMdZq_khcjZBTaV5=qW0x8_Q@mail.gmail.com>
Subject: Re: [net-next] tcp: add TCP_INFO status for failed client TFO
To:     Jason Baron <jbaron@akamai.com>
Cc:     David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Netdev <netdev@vger.kernel.org>,
        Christoph Paasch <cpaasch@apple.com>,
        Yuchung Cheng <ycheng@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 18, 2019 at 3:03 PM Jason Baron <jbaron@akamai.com> wrote:
>
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
>
> Signed-off-by: Jason Baron <jbaron@akamai.com>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Neal Cardwell <ncardwell@google.com>
> Cc: Christoph Paasch <cpaasch@apple.com>
> ---

Thanks for adding this!

It would be good to reset tp->fastopen_client_fail to 0 in tcp_disconnect().

> +/* why fastopen failed from client perspective */
> +enum tcp_fastopen_client_fail {
> +       TFO_STATUS_UNSPEC, /* catch-all */
> +       TFO_NO_COOKIE_SENT, /* if not in TFO_CLIENT_NO_COOKIE mode */
> +       TFO_NO_SYN_DATA, /* SYN-ACK did not ack SYN data */

I found the "TFO_NO_SYN_DATA" name a little unintuitive; it sounded to
me like this means the client didn't send a SYN+DATA. What about
"TFO_DATA_NOT_ACKED", or something like that?

If you don't mind, it would be great to cc: Yuchung on the next rev.

thanks,
neal
