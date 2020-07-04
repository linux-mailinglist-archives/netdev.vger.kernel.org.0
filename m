Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72D36214911
	for <lists+netdev@lfdr.de>; Sun,  5 Jul 2020 00:52:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727998AbgGDWvC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Jul 2020 18:51:02 -0400
Received: from mx2.suse.de ([195.135.220.15]:48922 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727929AbgGDWvC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 4 Jul 2020 18:51:02 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id D3F8AACF0;
        Sat,  4 Jul 2020 22:50:59 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 12755604BB; Sun,  5 Jul 2020 00:50:57 +0200 (CEST)
Date:   Sun, 5 Jul 2020 00:50:57 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Govindarajulu Varadarajan <gvaradar@cisco.com>
Cc:     netdev@vger.kernel.org, edumazet@google.com,
        linville@tuxdriver.com, govind.varadar@gmail.com
Subject: Re: [PATCH ethtool 1/2] ethtool: add support for get/set
 ethtool_tunable
Message-ID: <20200704225057.srqu6ylhhh2rnsqp@lion.mk-sys.cz>
References: <20200608175255.3353-1-gvaradar@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200608175255.3353-1-gvaradar@cisco.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I'm sorry it took me so long to get to this patch; I wanted to review it
two weeks ago but we had problems with e-mail migration and it took me
some time to recover missing mails.

On Mon, Jun 08, 2020 at 10:52:54AM -0700, Govindarajulu Varadarajan wrote:
> Add support for ETHTOOL_GTUNABLE and ETHTOOL_STUNABLE options.
> 
> Tested rx-copybreak on enic driver. Tested ETHTOOL_TUNNABLE_STRING
                                                     TUNABLE
> options with test/debug changes in kernel.

This makes me wonder how are string tunables supposed to work.
Unfortunately there is neither documentation nor code one could look at.
I tried to understand it from this patch but it didn't help much either:
do_stunable() will pass a string of arbitrary size to kernel but
do_gtunable() allocates a buffer of fixed size (for a given tunable).
Is this supposed to be the maximum value length? Or is kernel going to
return an error if the buffer is insufficient and userspace repeats the
request?

> Signed-off-by: Govindarajulu Varadarajan <gvaradar@cisco.com>
> ---
>  ethtool.c | 227 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 227 insertions(+)
> 
> diff --git a/ethtool.c b/ethtool.c
> index 900880a..6cff5dd 100644
> --- a/ethtool.c
> +++ b/ethtool.c
> @@ -4731,6 +4731,217 @@ static int do_seee(struct cmd_context *ctx)
>  	return 0;
>  }
>  
> +/* copy of net/ethtool/common.c */
> +char
> +tunable_strings[__ETHTOOL_TUNABLE_COUNT][ETH_GSTRING_LEN] = {
> +	[ETHTOOL_ID_UNSPEC]     = "Unspec",
> +	[ETHTOOL_RX_COPYBREAK]	= "rx-copybreak",
> +	[ETHTOOL_TX_COPYBREAK]	= "tx-copybreak",
> +	[ETHTOOL_PFC_PREVENTION_TOUT] = "pfc-prevention-tout",
> +};

Please align the right sides of the initializations.

> +
> +struct ethtool_tunable_info {
> +	enum tunable_id t_id;
> +	enum tunable_type_id t_type_id;
> +	size_t size;
> +	cmdline_type_t type;
> +	union val {
> +		u8 u8;
> +		u16 u16;
> +		u32 u32;
> +		u64 u64;
> +		int8_t s8;
> +		int16_t s16;
> +		int32_t s32;
> +		int64_t s64;
> +		void *str;
> +	} seen;
> +	union val wanted;
> +};

As the union type is used twice, it would make more sense to define it
outside of the struct declaration. However, seen is always used as int
so it's not clear why you declare it as the union.

Also, it's inconsistent to use kernel integer types for some tunable
types and standard C90 types for the others.

> +struct ethtool_tunable_info tinfo[] = {

Given the length of ethtool.c and amount of code for different
subcommands in it, please use more specific name than "tinfo", rather
something like "tunables_info". Also, it should be static.

> +	{ .t_id = ETHTOOL_RX_COPYBREAK,
> +	  .t_type_id = ETHTOOL_TUNABLE_U32,
> +	  .size = sizeof(u32),
> +	  .type = CMDL_U32,
> +	},
> +	{ .t_id = ETHTOOL_TX_COPYBREAK,
> +	  .t_type_id = ETHTOOL_TUNABLE_U32,
> +	  .size = sizeof(u32),
> +	  .type = CMDL_U32,
> +	},
> +	{ .t_id = ETHTOOL_PFC_PREVENTION_TOUT,
> +	  .t_type_id = ETHTOOL_TUNABLE_U16,
> +	  .size = sizeof(u16),
> +	  .type = CMDL_U16,
> +	},
> +};
> +#define TINFO_SIZE	ARRAY_SIZE(tinfo)
> +
> +static int do_stunable(struct cmd_context *ctx)
> +{
> +	struct cmdline_info cmdline_tunable[TINFO_SIZE];
> +	int changed = 0;
> +	int i;
> +
> +	for (i = 0; i < TINFO_SIZE; i++) {
> +		cmdline_tunable[i].name = tunable_strings[tinfo[i].t_id];
> +		cmdline_tunable[i].type = tinfo[i].type;
> +		cmdline_tunable[i].wanted_val = &tinfo[i].wanted;
> +		cmdline_tunable[i].seen_val = &tinfo[i].seen;
> +	}
> +
> +	parse_generic_cmdline(ctx, &changed, cmdline_tunable, TINFO_SIZE);
> +	if (!changed)
> +		exit_bad_args();
> +
> +	for (i = 0; i < TINFO_SIZE; i++) {
> +		char **val = (char **)&tinfo[i].wanted;
> +		struct ethtool_tunable *tuna;
> +		size_t size;
> +		int *seen;
> +		int ret;
> +
> +		seen = (int *)(&tinfo[i].seen);
> +		if (!*seen)
> +			continue;
> +
> +		size = sizeof(*tuna);
> +		if (tinfo[i].type == CMDL_STR) {
> +			size +=  strlen(*val) + 1;
> +		} else {
> +			size += tinfo[i].size;
> +		}

The curly braces are not needed here.

> +		tuna = calloc(1, size);
> +		if (!tuna) {
> +			perror(tunable_strings[tinfo[i].t_id]);
> +			return 1;
> +		}
> +		tuna->cmd = ETHTOOL_STUNABLE;
> +		tuna->id = tinfo[i].t_id;
> +		tuna->type_id = tinfo[i].t_type_id;
> +		if (tinfo[i].type == CMDL_STR) {
> +			tuna->len = strlen(*val) + 1;
> +			memcpy(tuna->data, *val, strlen(*val) + 1);
> +		} else {
> +			tuna->len = tinfo[i].size;
> +			memcpy(tuna->data, &tinfo[i].wanted, tuna->len);
> +		}
> +		ret = send_ioctl(ctx, tuna);
> +		if (ret) {
> +			perror(tunable_strings[tuna->id]);
> +			return ret;
> +		}
> +		free(tuna);
> +		tuna = NULL;

This seems pointless, variable tuna is not (guaranteed to be) preserved
between iterations and even if it were, there would be no need to zero
it here as if the value did matter, it would be uninitialized on first
iteration.

> +		/* reset seen and wanted to 0 */
> +		memset(&tinfo[i].seen, 0, sizeof(tinfo[i].seen));
> +		memset(&tinfo[i].wanted, 0, sizeof(tinfo[i].seen));

Comments should not say what you are doing but why. In this case, I do
not see why do you need to clear these as you are not going to use
either of them again.

> +	}
> +	return 0;
> +}
> +
> +static void print_tunable(struct ethtool_tunable *tuna)
> +{
> +	char *name = tunable_strings[tuna->id];
> +	u8 *val_u8;
> +	u16 *val_u16;
> +	u32 *val_u32;
> +	u64 *val_u64;
> +	int8_t *val_s8;
> +	int16_t *val_s16;
> +	int32_t *val_s32;
> +	long long int *val_s64;
> +	char *val_str;

Why don't you reuse the union from struct ethtool_tunable_info? You
could then replace all the val_* assignments with

	const union tunable_val *val = (const union tunable_val *)tuna->data;

and use union members in (f)printf() calls below.

> +
> +	switch (tuna->type_id) {
> +	case ETHTOOL_TUNABLE_U8:
> +		val_u8 = (u8 *)tuna->data;
> +		fprintf(stdout, "%s: %u\n", name, *val_u8);
> +		break;
> +	case ETHTOOL_TUNABLE_U16:
> +		val_u16 = (u16 *)tuna->data;
> +		fprintf(stdout, "%s: %u\n", name, *val_u16);
> +		break;
> +	case ETHTOOL_TUNABLE_U32:
> +		val_u32 = (u32 *)tuna->data;
> +		fprintf(stdout, "%s: %u\n", name, *val_u32);
> +		break;
> +	case ETHTOOL_TUNABLE_U64:
> +		val_u64 = (u64 *)tuna->data;
> +		fprintf(stdout, "%s: %llu\n", name, *val_u64);
> +		break;
> +	case ETHTOOL_TUNABLE_S8:
> +		val_s8 = (int8_t *)tuna->data;
> +		fprintf(stdout, "%s: %d\n", name, *val_s8);
> +		break;
> +	case ETHTOOL_TUNABLE_S16:
> +		val_s16 = (int16_t *)tuna->data;
> +		fprintf(stdout, "%s: %d\n", name, *val_s16);
> +		break;
> +	case ETHTOOL_TUNABLE_S32:
> +		val_s32 = (int32_t *)tuna->data;
> +		fprintf(stdout, "%s: %d\n", name, *val_s32);
> +		break;
> +	case ETHTOOL_TUNABLE_S64:
> +		val_s64 = (long long int *)tuna->data;
> +		fprintf(stdout, "%s: %lld\n", name, *val_s64);
> +		break;
> +	case ETHTOOL_TUNABLE_STRING:
> +		val_str = (char *)tuna->data;
> +		fprintf(stdout, "%s: %s\n", name, val_str);
> +		break;
> +	default:
> +		fprintf(stdout, "%s: Unknown format\n", name);
> +	}
> +}
> +
> +static int do_gtunable(struct cmd_context *ctx)
> +{
> +	char **argp = ctx->argp;
> +	int argc = ctx->argc;
> +	int i;
> +	int j;
> +
> +	if (argc < 1)
> +		exit_bad_args();
> +
> +	for (i = 0; i < argc; i++) {
> +		int valid = 0;
> +
> +		for (j = 0; j < TINFO_SIZE; j++) {
> +			char *ts = tunable_strings[tinfo[j].t_id];
> +			struct ethtool_tunable *tuna;
> +			int ret;
> +
> +			if (strcmp(argp[i], ts))
> +				continue;
> +			valid = 1;
> +
> +			tuna = calloc(1, sizeof(*tuna) + tinfo[j].size);
> +			if (!tuna) {
> +				perror(ts);
> +				return 1;
> +			}
> +			tuna->cmd = ETHTOOL_GTUNABLE;
> +			tuna->id = tinfo[j].t_id;
> +			tuna->type_id = tinfo[j].t_type_id;
> +			tuna->len = tinfo[j].size;
> +			ret = send_ioctl(ctx, tuna);
> +			if (ret) {
> +				fprintf(stderr, "%s: Cannot get tunable\n", ts);
> +				return ret;
> +			}
> +			print_tunable(tuna);
> +			free(tuna);
> +			tuna = NULL;

As in do_stunable(), no need to reset tuna here.

> +		}
> +		if (!valid)
> +			exit_bad_args();
> +	}
> +	return 0;
> +}
> +
>  static int do_get_phy_tunable(struct cmd_context *ctx)
>  {
>  	int argc = ctx->argc;
> @@ -5468,6 +5679,22 @@ static const struct option args[] = {
>  			  "		[ fast-link-down ]\n"
>  			  "		[ energy-detect-power-down ]\n"
>  	},
> +	{
> +		.opts	= "-b|--get-tunable",
> +		.func	= do_gtunable,
> +		.help	= "Get tunable",
> +		.xhelp	= "		[ rx-copybreak ]\n"
> +			  "		[ tx-copybreak ]\n"
> +			  "		[ pfc-precention-tout ]\n"
> +	},
> +	{
> +		.opts	= "-B|--set-tunable",
> +		.func	= do_stunable,
> +		.help	= "Set tunable",
> +		.xhelp	= "		[ rx-copybreak N]\n"
> +			  "		[ tx-copybreak N]\n"
> +			  "		[ pfc-precention-tout N]\n"
> +	},
>  	{
>  		.opts	= "--reset",
>  		.func	= do_reset,

I don't think tunables are so basic that they would need one-letter
command line options. Actually, I'm not sure if we even need to add more
tunables when we can add netlink attributes to any request type.

Michal

> -- 
> 2.27.0
> 
