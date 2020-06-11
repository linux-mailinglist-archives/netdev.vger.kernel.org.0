Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51B471F68F6
	for <lists+netdev@lfdr.de>; Thu, 11 Jun 2020 15:18:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728183AbgFKNSm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jun 2020 09:18:42 -0400
Received: from mout.web.de ([212.227.17.11]:56137 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726471AbgFKNSk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Jun 2020 09:18:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1591881447;
        bh=1x8I6rmlE7srvVzxBfIvVoevQkm/rDuU1cM8Wqa6FQM=;
        h=X-UI-Sender-Class:To:Cc:Subject:From:Date;
        b=aorjJjKxCJPafBe+gGjOnOCrCAFL0WACjt5B/NqN/Pk6rqsc9vH8pFTxK5ou655Mi
         Gj74LngJz1aVAfQJeq+gQOQEjsgV2wLy5sRL1UrJx9lEceg6TSdzKMzCi65uYl3702
         O21tH1bJqpPBP2UmniqUURW6nryPz23lfo0hKqCU=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([78.49.66.14]) by smtp.web.de (mrweb106
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1MHmqC-1jfUvY3ZiQ-00F14Z; Thu, 11
 Jun 2020 15:17:27 +0200
To:     Chen Wandun <chenwandun@huawei.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Yonghong Song <yhs@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Cheng Jian <cj.chengjian@huawei.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Ian Rogers <irogers@google.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Leo Yan <leo.yan@linaro.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [PATCH] perf tools: Fix potential memory leak in perf events
 parser
From:   Markus Elfring <Markus.Elfring@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <ea548157-5cb0-ffa7-9bd5-ff3f9c66b1de@web.de>
Date:   Thu, 11 Jun 2020 15:17:17 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:VfXqilX/ctjMS3JSH21x7PnlwcGZ5vUROMoGbWH56Xq7fxxUlyB
 nRFPmwFKI/feyleg0R3YgVhKIroLUkNYtFmTbQG17MbV26/YxCH3Z0BTu7eK1KlQ7ldraPz
 BFjciKLhE45DAqjyHdx1E/dQeBgDnBZy4fS49PaekpL/Z0Nbhn4b3gpCmF3tghZVNlmpWXB
 /0ENK0oeyazEcZcANQdhQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:Dy13m/PW6BE=:AxWZO4t9w1RVipMW6rcQAi
 H+o7qUjxSGjXd4ljPXEVSaQ0G+RNf5z6xJ+n8BT0jwUHmV8EZAipqABur8VmPJJ1/aA8jtFTI
 URGRrT0NDOv8EcCIGb88F4AWNS+k86OLEiXcUQYDR/HZI1fMN3pIIX6xOqR98AenpA+2yhcPg
 ICd0NXFQDQq/eveLrXMThVlPYKqUjxJJZB0GN4heUS0J62lFxTpK/F5EceqG9/EGCkLpWPPxS
 OvIZ7wGXt6phIU9qidLkWwIG7YgxDXcsWTyvLjmWPWK9wQPQsUyWdqfR62KtiI1Yf07ME8S/g
 09vIVbwWFkwWhNI+4Yj0hl+H/YnD4UG3PgiUbWfjhkyIggocWNmLnMGH5iMy4x03oRj/dHYCP
 mrom08fi/BkfLOichrkCTQspngOsUDpMtyciXqcH9qY5cI3ZGhlDm8UTVGodtRTAlq2Eg1Y+6
 lLBIVFKakUTSNkStj/6N6HFwuXylx2kLI/xZxa4drPgRASG5LwAeU12hZQ4JjPDxFCetMLku3
 /pGtQGyfAausUmDYqUkGxGMsPzg2KQIEUV77ujiWKE6crZuI4vf9Wdfo1nGigAr62s9Aqt4DU
 tjpe8WmqNaWcQuKMCbJJFufqFeLAtFlOjRBPxNRRVZjJ6Z3u+0zmXA5FlGXxIu+2ol90Mfpe0
 dKMS2BzzWliUujaIBphZYHcHgrrCJou/dX6M9sxem/vl67C+SXT9yhCd1uBI9Tv8IOa6i5zXD
 O1vMNRbO7+Y9cbUFm79Qb5RVF99fM+2Zpc+fvEV8EtS6mWKXKsBIi/RI8OouYAfK+7/FO2JAa
 RDdU91co8hToW+PBBTgoUoBunbwRDLvsyRtkVthmRavC+fNJxyc9YWK97dkcP6uhOKU7hDXdm
 qsbIvnZrGJgVYaZJDwx4NQnOc15p2A06+uf3wfd21MimwGBPTJJFh+DARTEtB8JrDuNZfIw/p
 ju4++SSQRw8sYV+Pa8/5AklRIvMmc15m8htWm5B/5D9A8GzEcIxT8oFy+vl8p5CiCAMCbxF+P
 9jqvNzl4nP0Hn8Xev/0GpSlvLhG+DMeeWqL+XrVMCAqKTBz9x2whtze/cX9Og+xFCKUIInddY
 CPhQweLukftc1Oo9FNKO9pGAs5vamq+gN0oymnoEA1Ig4m/HyM/jQ7/hDUdeYhx7hFxR/falI
 nbj322psrMqS2RNVnZm0YqtlJiw63vAxYQ6we9P7l54lJEmKbPpuuLGphmlhoS9c0utiAa/T5
 Qsikbc8LccjMXFOYc
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Fix potential memory leak in function parse_events_term__sym_hw()
> and parse_events_term__clone().

Would you like to add the tag =E2=80=9CFixes=E2=80=9D to the commit messag=
e?


=E2=80=A6
> +++ b/tools/perf/util/parse-events.c
=E2=80=A6
> @@ -2957,9 +2958,20 @@  int parse_events_term__sym_hw(struct parse_event=
s_term **term,
>  	sym =3D &event_symbols_hw[idx];
>
>  	str =3D strdup(sym->symbol);
> -	if (!str)
> +	if (!str) {
> +		if (!config)
> +			free(temp.config);
>  		return -ENOMEM;
> -	return new_term(term, &temp, str, 0);
> +	}
> +
> +	ret =3D new_term(term, &temp, str, 0);
> +	if (ret < 0) {
> +		free(str);
> +		if (!config)
> +			free(temp.config);
> +	}
> +
> +	return ret;
>  }
=E2=80=A6

How do you think about to add jump targets for a bit of
common exception handling code in these function implementations?

Regards,
Markus
