Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CED5244B0B
	for <lists+netdev@lfdr.de>; Fri, 14 Aug 2020 16:05:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727929AbgHNOFZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Aug 2020 10:05:25 -0400
Received: from mail.efficios.com ([167.114.26.124]:42112 "EHLO
        mail.efficios.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726706AbgHNOFW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Aug 2020 10:05:22 -0400
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id F28542E7E23;
        Fri, 14 Aug 2020 10:05:20 -0400 (EDT)
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id qpFD0rIEYa4Q; Fri, 14 Aug 2020 10:05:20 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id AD9F92E7C89;
        Fri, 14 Aug 2020 10:05:20 -0400 (EDT)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.efficios.com AD9F92E7C89
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
        s=default; t=1597413920;
        bh=ezFuUeP2uWgg8JJIlZA8XGQl5+/G+O/dmRGgk5g3eS8=;
        h=Date:From:To:Message-ID:MIME-Version;
        b=koI94SeKxbNFCit9ju0/fT9XgY+uzkDCxSKRLPSM/If/lJwxeTyBZnrQjrVc+n+JB
         xeMW57aZO39FAZO8mpDxbbn90ZUlXxSZ7bf0DH/yTbtg+t7avO+AFmdmrIcTtJPBKR
         3diXVqIcTfGXG9AQqIqxAjvAm1G4kRJMI9EepKsu5KH6ePWViZ//cS83l2lXvTxr8w
         71NiVaJLBUWPyVadD4LTVoVZvArvCpsXnvwE00pzZ2/lsl0d3qLVRPQNRYk3OZDYwU
         GZK3eTRTpCDmtdR2q5RgBppxiehV5WpHN3P7ThINX7PRwE5+bYRTXHmy1MmI0j04zI
         MWe7VuBzNcelg==
X-Virus-Scanned: amavisd-new at efficios.com
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id MkBH6ZSZSQF8; Fri, 14 Aug 2020 10:05:20 -0400 (EDT)
Received: from mail03.efficios.com (mail03.efficios.com [167.114.26.124])
        by mail.efficios.com (Postfix) with ESMTP id 9F6AC2E7C87;
        Fri, 14 Aug 2020 10:05:20 -0400 (EDT)
Date:   Fri, 14 Aug 2020 10:05:20 -0400 (EDT)
From:   Michael Jeanson <mjeanson@efficios.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        David Ahern <dsahern@kernel.org>, linux-kernel@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Message-ID: <217122726.8258.1597413920624.JavaMail.zimbra@efficios.com>
In-Reply-To: <49f26c7d-b8aa-57e7-02c6-424bec9c3845@gmail.com>
References: <20200811195003.1812-1-mathieu.desnoyers@efficios.com> <20200811195003.1812-2-mathieu.desnoyers@efficios.com> <49f26c7d-b8aa-57e7-02c6-424bec9c3845@gmail.com>
Subject: Re: [PATCH 1/3] selftests: Add VRF icmp error route lookup test
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [167.114.26.124]
X-Mailer: Zimbra 8.8.15_GA_3959 (ZimbraWebClient - GC84 (Linux)/8.8.15_GA_3953)
Thread-Topic: selftests: Add VRF icmp error route lookup test
Thread-Index: L7PbwFLrYb4o0H7ABrtySfFz4apuVQ==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

----- On 13 Aug, 2020, at 19:13, David Ahern dsahern@gmail.com wrote:

...

>> +ipv6_ping()
>> +{
>> +	log_section "IPv6: VRF ICMP error route lookup ping"
>> +
>> +	setup
>> +
>> +	# verify connectivity
>> +	if ! check_connectivity6; then
>> +		echo "Error: Basic connectivity is broken"
>> +		ret=1
>> +		return
>> +	fi
>> +
>> +	if [ "$VERBOSE" = "1" ]; then
>> +		echo "Command to check for ICMP ttl exceeded:"
>> +		run_cmd ip netns exec h1 "${ping6}" -t1 -c1 -W2 ${H2_N2_IP6}
>> +	fi
>> +
>> +	ip netns exec h1 "${ping6}" -t1 -c1 -W2 ${H2_N2_IP6} | grep -q "Time exceeded:
>> Hop limit"
> 
> run_cmd runs the command and if VERBOSE is set to 1 shows the command to
> the user. Something is off with this script and passing the -v arg -- I
> do not get a command list. This applies to the whole script.

Hum, I have no issues here with '-v', you get no output at all from run_cmd?

> 
> Since you need to check for output, I suggest modifying run_cmd to
> search the output for the given string.

I took this pattern of executing commands twice when running with verbose and
grepping the output from icmp_redirect.sh. I'll see if I can come up with
something fancier in run_cmd.


>> +	log_test $? 0 "Ping received ICMP ttl exceeded"
>> +}
>> +################################################################################
> 
> missing newline between '}' and '####'

Ack

...

>> +while getopts :46pvh o
>> +do
>> +	case $o in
>> +		4) TESTS=ipv4;;
>> +		6) TESTS=ipv6;;
>> +                p) PAUSE_ON_FAIL=yes;;
>> +                v) VERBOSE=1;;
>> +		h) usage; exit 0;;
>> +                *) usage; exit 1;;
> 
> indentation issues; not using tabs
> 

Ack

>> +	esac
>> +done
>> +
>> +#
>> +# show user test config
>> +#
>> +if [ -z "$TESTS" ]; then
>> +        TESTS="$TESTS_IPV4 $TESTS_IPV6"
>> +elif [ "$TESTS" = "ipv4" ]; then
>> +        TESTS="$TESTS_IPV4"
>> +elif [ "$TESTS" = "ipv6" ]; then
>> +        TESTS="$TESTS_IPV6"
>> +fi
>> +
>> +for t in $TESTS
>> +do
>> +	case $t in
>> +	ipv4_ping|ping)             ipv4_ping;;
>> +	ipv4_traceroute|traceroute) ipv4_traceroute;;
>> +
>> +	ipv6_ping|ping)             ipv6_ping;;
>> +	ipv6_traceroute|traceroute) ipv6_traceroute;;
>> +
>> +	# setup namespaces and config, but do not run any tests
>> +	setup)                      setup; exit 0;;
> 
> you don't allow '-t setup' so you can remove this part

I'l add the missing '-t' option to getopts.

> 
>> +
>> +	help)                       echo "Test names: $TESTS"; exit 0;;
>> +	esac
>> +done
>> +
>> +cleanup
>> +
>> +printf "\nTests passed: %3d\n" ${nsuccess}
>> +printf "Tests failed: %3d\n"   ${nfail}
>> +
>> +exit $ret
