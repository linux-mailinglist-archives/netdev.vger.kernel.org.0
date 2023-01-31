Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54B5F682E08
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 14:34:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232297AbjAaNeR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 08:34:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232287AbjAaNeJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 08:34:09 -0500
Received: from mail-yw1-x112d.google.com (mail-yw1-x112d.google.com [IPv6:2607:f8b0:4864:20::112d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79D9324138
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 05:34:00 -0800 (PST)
Received: by mail-yw1-x112d.google.com with SMTP id 00721157ae682-5063029246dso203022747b3.6
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 05:34:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=UfAxiDAmvznYrbgPrLSyoN97qBwE5q5NN2eH2aFQI+Q=;
        b=R/eHb6Npg6vVgzTXkX8g8LE9Y5MUKvgwQf8Anu/dR7BGaQZkf7gp5So/Fqw4Aoc+Xf
         Fl2GfNdYxfHhgB+OB+04F3HGhZ2gaaCqVvVowEaxe8yW0THaQRVCnATBgcZKjZrDKKh0
         LLl7z4LnS2f0cE1IllrwZ1DYrgjzTi1O6I5VWoH9oaydSen0op/WFiuSnZcz2wQ986Ux
         WoQcxHWDU7Y92mkQJRDrE33K7elATYpeuO6uqOACpTG09Y8pznpawgFdDnUNrkSPFS6f
         qnJL1tvO/g07xZ07xZ/FMnri8/sP3dKKz8CowWHsnKcjQTlY9x1qIwtN29JMFC2o+jwv
         7e5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UfAxiDAmvznYrbgPrLSyoN97qBwE5q5NN2eH2aFQI+Q=;
        b=WpBGUNE0ZNPu4ZewbizrDgB8FPwEGFKiKpHXbx1I4UZKUJfIyVa+ikwoQDF+yh7BcB
         JIjTBq8ZciTVVVGmF8bh7iOGwZV3rQAYDgGzGufYqqswTVaQBFAah5Zj6VEFVeZoYrqt
         SveDBa9DIn8Icsys522QtDxSjWQlByW0OtspI35s7/5vnewAbRcmkZavrzcPvamqYWot
         GpbZQnb4Cx6iOI0+A2PCQxqmYnmTU5vQAPdddLIoR3BMJZJyooaCVYhT3Ucc7o/hPU4Q
         /E3gaSoLTlHbDUbUr43pokPeAZ8DXUysdzmoQUe42qA+aCLkm7xy4nAVm8A9hWP8JpTn
         moqw==
X-Gm-Message-State: AO0yUKWtgJZw+UziIswSCW54oWfeh7ol0juyv9zOr2FeVpTETPwEsEep
        Qs/oQCmm7HjsYioJpQK6bimEQ0Y1QSImXUhPKEs6XA==
X-Google-Smtp-Source: AK7set/Jg9zDWxUGopNUlLIrLYvWe6RszOxFMimwmW9N+5DWMWHJD6setkT7/38T/PwmMccANZj0Yfz+3EoYA+5Mnd8=
X-Received: by 2002:a81:a211:0:b0:506:6a3a:abde with SMTP id
 w17-20020a81a211000000b005066a3aabdemr3012120ywg.43.1675172039574; Tue, 31
 Jan 2023 05:33:59 -0800 (PST)
MIME-Version: 1.0
References: <20230131130412.432549-1-andrei.gherzan@canonical.com> <20230131130412.432549-3-andrei.gherzan@canonical.com>
In-Reply-To: <20230131130412.432549-3-andrei.gherzan@canonical.com>
From:   Willem de Bruijn <willemb@google.com>
Date:   Tue, 31 Jan 2023 08:33:23 -0500
Message-ID: <CA+FuTSdtzFXWWDLk=LOdrkS00oH4HGvtoYYQh7YQd2ADsp0UbA@mail.gmail.com>
Subject: Re: [PATCH v2 3/4] selftests: net: udpgso_bench: Fix racing bug
 between the rx/tx programs
To:     Andrei Gherzan <andrei.gherzan@canonical.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 31, 2023 at 8:06 AM Andrei Gherzan
<andrei.gherzan@canonical.com> wrote:
>
> "udpgro_bench.sh" invokes udpgso_bench_rx/udpgso_bench_tx programs
> subsequently and while doing so, there is a chance that the rx one is not
> ready to accept socket connections. This racing bug could fail the test
> with at least one of the following:
>
> ./udpgso_bench_tx: connect: Connection refused
> ./udpgso_bench_tx: sendmsg: Connection refused
> ./udpgso_bench_tx: write: Connection refused
>
> This change addresses this by making udpgro_bench.sh wait for the rx
> program to be ready before firing off the tx one - with an exponential back
> off algorithm from 1s to 10s.
>
> Signed-off-by: Andrei Gherzan <andrei.gherzan@canonical.com>

please CC: reviewers of previous revisions on new revisions

also for upcoming patches: please clearly mark net or net-next.
> ---
>  tools/testing/selftests/net/udpgso_bench.sh | 18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
>
> diff --git a/tools/testing/selftests/net/udpgso_bench.sh b/tools/testing/selftests/net/udpgso_bench.sh
> index dc932fd65363..20b5db8fcbde 100755
> --- a/tools/testing/selftests/net/udpgso_bench.sh
> +++ b/tools/testing/selftests/net/udpgso_bench.sh
> @@ -7,6 +7,7 @@ readonly GREEN='\033[0;92m'
>  readonly YELLOW='\033[0;33m'
>  readonly RED='\033[0;31m'
>  readonly NC='\033[0m' # No Color
> +readonly TESTPORT=8000 # Keep this in sync with udpgso_bench_rx/tx

then also pass explicit -p argument to the processes to keep all three
consistent

>
>  readonly KSFT_PASS=0
>  readonly KSFT_FAIL=1
> @@ -56,10 +57,27 @@ trap wake_children EXIT
>
>  run_one() {
>         local -r args=$@
> +       local -r init_delay_s=1
> +       local -r max_delay_s=10
> +       local delay_s=0
> +       local nr_socks=0
>
>         ./udpgso_bench_rx &
>         ./udpgso_bench_rx -t &
>
> +       # Wait for the above test program to get ready to receive connections.
> +       delay_s="${init_delay_s}"
> +       while [ "$delay_s" -lt "$max_delay_s" ]; do
> +               nr_socks="$(ss -lnHi | grep -c "\*:${TESTPORT}")"
> +               [ "$nr_socks" -eq 2 ] && break
> +               sleep "$delay_s"
> +               delay="$((delay*2))"

I don't think we need exponential back-off for something this simple

> +       done
> +       if [ "$nr_socks" -ne 2 ]; then
> +               echo "timed out while waiting for udpgso_bench_rx"
> +               exit 1
> +       fi
> +
>         ./udpgso_bench_tx ${args}
>  }
>
> --
> 2.34.1
>
