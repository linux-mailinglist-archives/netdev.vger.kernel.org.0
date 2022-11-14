Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8F6C62851C
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 17:25:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237160AbiKNQZK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 11:25:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236334AbiKNQZI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 11:25:08 -0500
Received: from mx0a-00190b01.pphosted.com (mx0a-00190b01.pphosted.com [IPv6:2620:100:9001:583::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18203E22;
        Mon, 14 Nov 2022 08:25:07 -0800 (PST)
Received: from pps.filterd (m0050093.ppops.net [127.0.0.1])
        by m0050093.ppops.net-00190b01. (8.17.1.19/8.17.1.19) with ESMTP id 2AEFx4gI026291;
        Mon, 14 Nov 2022 16:24:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=jan2016.eng;
 bh=boc4w+PutdRa5i975DOUeNjWMrbdjVCCGWGYmKFDTWk=;
 b=h7hkO73hNumxE4A1Gtykj4VAKPEmoYMcqacbE7gv37lPcvvGYEIEmrORC9kHbJ+vSdGH
 vQvVmBeYbCcIKjiudNFd+ZMN1GK6luobmd3tWSWe7+AtsU6ICduvLCnVn29n3/F3H5Uf
 gg86l1boAQJwPqV5L6nBV+7DVvxhx3JUfuAnUKiaQH1IkCJBhs8mEjTp6f3CaVOsYvOm
 BjzqfRGHrWMqN5PnZUJYhIuuQHFeA4854UlvH95UeZlRy6jcqLHWZ34uOdCbH7kUUFyF
 dvzdijmg+NsdW4P51xPMJnElM2UDwddMddf9UUxDQNlt2mB08c+JqXnlB0goIAIOTs02 hw== 
Received: from prod-mail-ppoint1 (prod-mail-ppoint1.akamai.com [184.51.33.18] (may be forged))
        by m0050093.ppops.net-00190b01. (PPS) with ESMTPS id 3kupb6ckm9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Nov 2022 16:24:18 +0000
Received: from pps.filterd (prod-mail-ppoint1.akamai.com [127.0.0.1])
        by prod-mail-ppoint1.akamai.com (8.17.1.5/8.17.1.5) with ESMTP id 2AEEWijw022729;
        Mon, 14 Nov 2022 11:24:17 -0500
Received: from prod-mail-relay11.akamai.com ([172.27.118.250])
        by prod-mail-ppoint1.akamai.com (PPS) with ESMTP id 3kt7q31n5p-1;
        Mon, 14 Nov 2022 11:24:17 -0500
Received: from [172.19.35.148] (bos-lpa4700a.bos01.corp.akamai.com [172.19.35.148])
        by prod-mail-relay11.akamai.com (Postfix) with ESMTP id DE8942F8B6;
        Mon, 14 Nov 2022 16:24:16 +0000 (GMT)
Message-ID: <ae9e4333-7070-d550-c0b5-f4d122d2f025@akamai.com>
Date:   Mon, 14 Nov 2022 11:24:17 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v3 1/3] jump_label: Prevent key->enabled int overflow
Content-Language: en-US
To:     Dmitry Safonov <dima@arista.com>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>
Cc:     Bob Gilligan <gilligan@arista.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Salam Noureddine <noureddine@arista.com>,
        netdev@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>
References: <20221111212320.1386566-1-dima@arista.com>
 <20221111212320.1386566-2-dima@arista.com>
From:   Jason Baron <jbaron@akamai.com>
In-Reply-To: <20221111212320.1386566-2-dima@arista.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-14_12,2022-11-11_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0 spamscore=0
 bulkscore=0 suspectscore=0 phishscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211140116
X-Proofpoint-GUID: DPrtwzoezN_Vdf9iGFZ3HZfW1OTY918I
X-Proofpoint-ORIG-GUID: DPrtwzoezN_Vdf9iGFZ3HZfW1OTY918I
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-14_12,2022-11-11_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 lowpriorityscore=0
 suspectscore=0 mlxscore=0 bulkscore=0 spamscore=0 priorityscore=1501
 impostorscore=0 clxscore=1011 phishscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211140116
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 11/11/22 16:23, Dmitry Safonov wrote:
> diff --git a/kernel/jump_label.c b/kernel/jump_label.c
> index 714ac4c3b556..f2c1aa351d41 100644
> --- a/kernel/jump_label.c
> +++ b/kernel/jump_label.c
> @@ -113,11 +113,38 @@ int static_key_count(struct static_key *key)
>  }
>  EXPORT_SYMBOL_GPL(static_key_count);
>  
> -void static_key_slow_inc_cpuslocked(struct static_key *key)
> +/***
> + * static_key_fast_inc - adds a user for a static key
> + * @key: static key that must be already enabled
> + *
> + * The caller must make sure that the static key can't get disabled while
> + * in this function. It doesn't patch jump labels, only adds a user to
> + * an already enabled static key.
> + *
> + * Returns true if the increment was done.
> + */
> +bool static_key_fast_inc(struct static_key *key)
>  {
>  	int v, v1;
>  
>  	STATIC_KEY_CHECK_USE(key);
> +	/*
> +	 * Negative key->enabled has a special meaning: it sends
> +	 * static_key_slow_inc() down the slow path, and it is non-zero
> +	 * so it counts as "enabled" in jump_label_update().  Note that
> +	 * atomic_inc_unless_negative() checks >= 0, so roll our own.
> +	 */
> +	for (v = atomic_read(&key->enabled); v > 0 && (v + 1) > 0; v = v1) {
> +		v1 = atomic_cmpxchg(&key->enabled, v, v + 1);
> +		if (likely(v1 == v))
> +			return true;
> +	}
> +	return false;
> +}
> +EXPORT_SYMBOL_GPL(static_key_fast_inc);
> +
> +bool static_key_slow_inc_cpuslocked(struct static_key *key)
> +{
>  	lockdep_assert_cpus_held();
>  
>  	/*
> @@ -126,17 +153,9 @@ void static_key_slow_inc_cpuslocked(struct static_key *key)
>  	 * jump_label_update() process.  At the same time, however,
>  	 * the jump_label_update() call below wants to see
>  	 * static_key_enabled(&key) for jumps to be updated properly.
> -	 *
> -	 * So give a special meaning to negative key->enabled: it sends
> -	 * static_key_slow_inc() down the slow path, and it is non-zero
> -	 * so it counts as "enabled" in jump_label_update().  Note that
> -	 * atomic_inc_unless_negative() checks >= 0, so roll our own.
>  	 */
> -	for (v = atomic_read(&key->enabled); v > 0; v = v1) {
> -		v1 = atomic_cmpxchg(&key->enabled, v, v + 1);
> -		if (likely(v1 == v))
> -			return;
> -	}
> +	if (static_key_fast_inc(key))
> +		return true;
>  
>  	jump_label_lock();
>  	if (atomic_read(&key->enabled) == 0) {
> @@ -148,16 +167,23 @@ void static_key_slow_inc_cpuslocked(struct static_key *key)
>  		 */
>  		atomic_set_release(&key->enabled, 1);
>  	} else {
> -		atomic_inc(&key->enabled);
> +		if (WARN_ON_ONCE(static_key_fast_inc(key))) {

Shouldn't that be negated to catch the overflow:

if (WARN_ON_ONCE(!static_key_fast_inc(key)))



> +			jump_label_unlock();
> +			return false;
> +		}
>  	}
>  	jump_label_unlock();
> +	return true;
>  }
>  
> -void static_key_slow_inc(struct static_key *key)
> +bool static_key_slow_inc(struct static_key *key)
>  {
> +	bool ret;
> +
>  	cpus_read_lock();
> -	static_key_slow_inc_cpuslocked(key);
> +	ret = static_key_slow_inc_cpuslocked(key);
>  	cpus_read_unlock();
> +	return ret;
>  }
>  EXPORT_SYMBOL_GPL(static_key_slow_inc);
>  
