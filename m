Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B663D215FAF
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 21:54:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725982AbgGFTyn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 15:54:43 -0400
Received: from out0-152.mail.aliyun.com ([140.205.0.152]:51246 "EHLO
        out0-152.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725892AbgGFTyn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 15:54:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=alibaba-inc.com; s=default;
        t=1594065281; h=Subject:To:From:Message-ID:Date:MIME-Version:Content-Type;
        bh=51mz9zmmJk640KnnFyPIYsKDhnD4dBFpYvQxyF74ArE=;
        b=gbQkgPDZE95xeLaNi5QfubZ0uz0ZZFVmq8yxTyIHVoqjG7mYNaMuNXLJ9uLq94MU9iFSpiB5bkCAvzwCfmJMitgg4+Eu2xu75COq9X9zyMx/kagTo3zM39NTCECrWNEc12xmFgzXJPgCVPBt5WflB7fZ4biyIhUhBpil4SFW7dI=
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R331e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e02c03299;MF=xiangning.yu@alibaba-inc.com;NM=1;PH=DS;RN=2;SR=0;TI=SMTPD_---.Hz2LvyQ_1594065279;
Received: from US-118000MP.local(mailfrom:xiangning.yu@alibaba-inc.com fp:SMTPD_---.Hz2LvyQ_1594065279)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 07 Jul 2020 03:54:40 +0800
Subject: Re: [PATCH iproute2-next] iproute2 Support lockless token bucket
 (LTB)
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org
References: <0010e146-ccda-ee6b-819b-96e518204f8a@alibaba-inc.com>
 <20200706114037.519161d0@hermes.lan>
From:   "=?UTF-8?B?WVUsIFhpYW5nbmluZw==?=" <xiangning.yu@alibaba-inc.com>
Message-ID: <d0ad669c-4203-9987-e625-f2fae4a6b81c@alibaba-inc.com>
Date:   Tue, 07 Jul 2020 03:54:38 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200706114037.519161d0@hermes.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/6/20 11:40 AM, Stephen Hemminger wrote:
> On Tue, 07 Jul 2020 02:08:21 +0800
> "YU, Xiangning" <xiangning.yu@alibaba-inc.com> wrote:
> 
>> +static int ltb_print_opt(struct qdisc_util *qu, FILE *f, struct rtattr *opt)
>> +{
>> +	struct rtattr *tb[TCA_LTB_MAX + 1];
>> +	struct tc_ltb_opt *lopt;
>> +	struct tc_ltb_glob *gopt;
>> +	__u64 rate64, ceil64;
>> +
>> +	SPRINT_BUF(b1);
>> +	if (opt == NULL)
>> +		return 0;
>> +
>> +	parse_rtattr_nested(tb, TCA_LTB_MAX, opt);
>> +
>> +	if (tb[TCA_LTB_PARMS]) {
>> +		lopt = RTA_DATA(tb[TCA_LTB_PARMS]);
>> +		if (RTA_PAYLOAD(tb[TCA_LTB_PARMS])  < sizeof(*lopt))
>> +			return -1;
>> +
>> +		fprintf(f, "prio %d ", (int)lopt->prio);
>> +
>> +		rate64 = lopt->rate.rate;
>> +		if (tb[TCA_LTB_RATE64] &&
>> +		    RTA_PAYLOAD(tb[TCA_LTB_RATE64]) >= sizeof(rate64)) {
>> +			rate64 = *(__u64 *)RTA_DATA(tb[TCA_LTB_RATE64]);
>> +		}
>> +
>> +		ceil64 = lopt->ceil.rate;
>> +		if (tb[TCA_LTB_CEIL64] &&
>> +		    RTA_PAYLOAD(tb[TCA_LTB_CEIL64]) >= sizeof(ceil64))
>> +			ceil64 = *(__u64 *)RTA_DATA(tb[TCA_LTB_CEIL64]);
>> +
>> +		fprintf(f, "rate %s ", sprint_rate(rate64, b1));
>> +		fprintf(f, "ceil %s ", sprint_rate(ceil64, b1));
> 
> The print function needs to support JSON output like the rest
> of the qdisc in current iproute2.
> 
Hi Stephen,

Thank you for pointing this out! While I'm a bit confused about the JSON output. This is a sample output of `tc -j class show` command. Looks like it doesn't display JSON output even for HTB. Am I missing anything? 

# ./tc -s  -j -p class show dev enp7s0f0
class htb 1:1 root rate 10Gbit ceil 10Gbit burst 13750b cburst 0b 
 Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0) 
 backlog 0b 0p requeues 0
 lended: 0 borrowed: 0 giants: 0
 tokens: 187 ctokens: 15

class htb 1:10 parent 1:1 prio 1 rate 10Gbit ceil 10Gbit burst 13750b cburst 13750b 
 Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0) 
 backlog 0b 0p requeues 0
 lended: 0 borrowed: 0 giants: 0
 tokens: 187 ctokens: 187

Thanks,
- Xiangning

