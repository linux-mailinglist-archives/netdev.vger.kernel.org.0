Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF854560764
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 19:33:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230009AbiF2RdE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 13:33:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbiF2RdD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 13:33:03 -0400
Received: from mout01.posteo.de (mout01.posteo.de [185.67.36.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4417735DDF
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 10:33:01 -0700 (PDT)
Received: from submission (posteo.de [185.67.36.169]) 
        by mout01.posteo.de (Postfix) with ESMTPS id B3FE624002A
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 19:32:59 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=posteo.net; s=2017;
        t=1656523979; bh=e3UzcE0gZuntK9S7N3Iw3VSU7kivNeJItC7WAz+6ZSo=;
        h=Date:From:To:Cc:Subject:From;
        b=aXBgghT8mruOHsw4wFPD4TPJfga4YfY6neUNy6u6aw7nBQMWNBwOc2j28OQ4OVLiN
         coIuAGAoDwKXZ2o6TgFD5O56xKnLefQHtrCVsi4vqMnG1wbDHC9GGv+1AuSDwcGGAl
         kmcEzGQVYnBO/42I2O/Yqs/4A4DeJ/wlDonihQ/0S9qqdmCoLqwVe6IkhJyNziaFBj
         4Noxa6CjAvL7lPtVrG3iaSUKZfH0Ys7WE5b/ErdI+sD1zZvOqFxMmc/bEMQlwIMfNx
         lWUKfP8xwJbpDHS4n/jzBq3ITdwGHm+QGkFkPETCsKD7keCKx57Bm0GfltxlMB6Nh3
         vB2qxDkkKoPsw==
Received: from customer (localhost [127.0.0.1])
        by submission (posteo.de) with ESMTPSA id 4LY7pG6kRwz9rxQ;
        Wed, 29 Jun 2022 19:32:54 +0200 (CEST)
Date:   Wed, 29 Jun 2022 17:32:51 +0000
From:   Daniel =?utf-8?Q?M=C3=BCller?= <deso@posteo.net>
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH bpf-next 1/2] bpftool: Add feature list
 (prog/map/link/attach types, helpers)
Message-ID: <20220629173251.zk33plyiqsrkfpzg@muellerd-fedora-MJ0AC3F3>
References: <20220629144019.75181-1-quentin@isovalent.com>
 <20220629144019.75181-2-quentin@isovalent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220629144019.75181-2-quentin@isovalent.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 29, 2022 at 03:40:18PM +0100, Quentin Monnet wrote:
> Add a "bpftool feature list" subcommand to list BPF "features".
> Contrarily to "bpftool feature probe", this is not about the features
> available on the system. Instead, it lists all features known to bpftool
> from compilation time; in other words, all program, map, attach, link
> types known to the libbpf version in use, and all helpers found in the
> UAPI BPF header.
> 
> The first use case for this feature is bash completion: running the
> command provides a list of types that can be used to produce the list of
> candidate map types, for example.
> 
> Now that bpftool uses "standard" names provided by libbpf for the
> program, map, link, and attach types, having the ability to list these
> types and helpers could also be useful in scripts to loop over existing
> items.
> 
> Sample output:
> 
>     # bpftool feature list prog_types | grep -vw unspec | head -n 6
>     socket_filter
>     kprobe
>     sched_cls
>     sched_act
>     tracepoint
>     xdp
> 
>     # bpftool -p feature list map_types | jq '.[1]'
>     "hash"
> 
>     # bpftool feature list attach_types | grep '^cgroup_'
>     cgroup_inet_ingress
>     cgroup_inet_egress
>     [...]
>     cgroup_inet_sock_release
> 
>     # bpftool feature list helpers | grep -vw bpf_unspec | wc -l
>     207
> 
> The "unspec" types and helpers are not filtered out by bpftool, so as to
> remain closer to the enums, and to preserve the indices in the JSON
> arrays (e.g. "hash" at index 1 == BPF_MAP_TYPE_HASH in map types list).
> 
> Signed-off-by: Quentin Monnet <quentin@isovalent.com>
> ---
>  .../bpftool/Documentation/bpftool-feature.rst | 12 ++++
>  tools/bpf/bpftool/bash-completion/bpftool     |  7 ++-
>  tools/bpf/bpftool/feature.c                   | 55 +++++++++++++++++++
>  3 files changed, 73 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/bpf/bpftool/Documentation/bpftool-feature.rst b/tools/bpf/bpftool/Documentation/bpftool-feature.rst
> index 4ce9a77bc1e0..4bf1724d0e8c 100644
> --- a/tools/bpf/bpftool/Documentation/bpftool-feature.rst
> +++ b/tools/bpf/bpftool/Documentation/bpftool-feature.rst
> @@ -24,9 +24,11 @@ FEATURE COMMANDS
>  ================
>  
>  |	**bpftool** **feature probe** [*COMPONENT*] [**full**] [**unprivileged**] [**macros** [**prefix** *PREFIX*]]
> +|	**bpftool** **feature list** *GROUP*
>  |	**bpftool** **feature help**
>  |
>  |	*COMPONENT* := { **kernel** | **dev** *NAME* }
> +|	*GROUP* := { **prog_types** | **map_types** | **attach_types** | **helpers** }

Is **link_types** missing from this enumeration?


>  DESCRIPTION
>  ===========
> @@ -70,6 +72,16 @@ DESCRIPTION
>  		  The keywords **full**, **macros** and **prefix** have the
>  		  same role as when probing the kernel.
>  
> +	**bpftool feature list** *GROUP*
> +		  List items known to bpftool. These can be BPF program types
> +		  (**prog_types**), BPF map types (**map_types**), attach types
> +		  (**attach_types**), link types (**link_types**), or BPF helper
> +		  functions (**helpers**). The command does not probe the system, but
> +		  simply lists the elements that bpftool knows from compilation time,
> +		  as provided from libbpf (for all object types) or from the BPF UAPI
> +		  header (list of helpers). This can be used in scripts to iterate over
> +		  BPF types or helpers.
> +
>  	**bpftool feature help**
>  		  Print short help message.
>  
> diff --git a/tools/bpf/bpftool/bash-completion/bpftool b/tools/bpf/bpftool/bash-completion/bpftool
> index 91f89a9a5b36..9cef6516320b 100644
> --- a/tools/bpf/bpftool/bash-completion/bpftool
> +++ b/tools/bpf/bpftool/bash-completion/bpftool
> @@ -1175,9 +1175,14 @@ _bpftool()
>                      _bpftool_once_attr 'full unprivileged'
>                      return 0
>                      ;;
> +                list)
> +                    [[ $prev != "$command" ]] && return 0
> +                    COMPREPLY=( $( compgen -W 'prog_types map_types \
> +                        attach_types link_types helpers' -- "$cur" ) )
> +                    ;;
>                  *)
>                      [[ $prev == $object ]] && \
> -                        COMPREPLY=( $( compgen -W 'help probe' -- "$cur" ) )
> +                        COMPREPLY=( $( compgen -W 'help list probe' -- "$cur" ) )
>                      ;;
>              esac
>              ;;
> diff --git a/tools/bpf/bpftool/feature.c b/tools/bpf/bpftool/feature.c
> index bac4ef428a02..576cc6b90c6a 100644
> --- a/tools/bpf/bpftool/feature.c
> +++ b/tools/bpf/bpftool/feature.c
> @@ -1258,6 +1258,58 @@ static int do_probe(int argc, char **argv)
>  	return 0;
>  }
>  
> +static const char *get_helper_name(unsigned int id)
> +{
> +	if (id >= ARRAY_SIZE(helper_name))
> +		return NULL;
> +
> +	return helper_name[id];
> +}
> +
> +static int do_list(int argc, char **argv)
> +{
> +	const char *(*get_name)(unsigned int id);
> +	unsigned int id = 0;
> +
> +	if (argc < 1)
> +		usage();
> +
> +	if (is_prefix(*argv, "prog_types")) {
> +		get_name = (const char *(*)(unsigned int))libbpf_bpf_prog_type_str;
> +	} else if (is_prefix(*argv, "map_types")) {
> +		get_name = (const char *(*)(unsigned int))libbpf_bpf_map_type_str;
> +	} else if (is_prefix(*argv, "attach_types")) {
> +		get_name = (const char *(*)(unsigned int))libbpf_bpf_attach_type_str;
> +	} else if (is_prefix(*argv, "link_types")) {
> +		get_name = (const char *(*)(unsigned int))libbpf_bpf_link_type_str;
> +	} else if (is_prefix(*argv, "helpers")) {
> +		get_name = get_helper_name;
> +	} else {
> +		p_err("expected 'prog_types', 'map_types', 'attach_types', 'link_types' or 'helpers', got: %s", *argv);
> +		return -1;
> +	}
> +
> +	if (json_output)
> +		jsonw_start_array(json_wtr);	/* root array */
> +
> +	while (true) {
> +		const char *name;
> +
> +		name = get_name(id++);
> +		if (!name)
> +			break;
> +		if (json_output)
> +			jsonw_string(json_wtr, name);
> +		else
> +			printf("%s\n", name);
> +	}
> +
> +	if (json_output)
> +		jsonw_end_array(json_wtr);	/* root array */
> +
> +	return 0;
> +}
> +
>  static int do_help(int argc, char **argv)
>  {
>  	if (json_output) {
> @@ -1267,9 +1319,11 @@ static int do_help(int argc, char **argv)
>  
>  	fprintf(stderr,
>  		"Usage: %1$s %2$s probe [COMPONENT] [full] [unprivileged] [macros [prefix PREFIX]]\n"
> +		"       %1$s %2$s list GROUP\n"
>  		"       %1$s %2$s help\n"
>  		"\n"
>  		"       COMPONENT := { kernel | dev NAME }\n"
> +		"       GROUP := { prog_types | map_types | attach_types | link_types | helpers }\n"
>  		"       " HELP_SPEC_OPTIONS " }\n"
>  		"",
>  		bin_name, argv[-2]);
> @@ -1279,6 +1333,7 @@ static int do_help(int argc, char **argv)
>  
>  static const struct cmd cmds[] = {
>  	{ "probe",	do_probe },
> +	{ "list",	do_list },
>  	{ "help",	do_help },
>  	{ 0 }
>  };
> -- 
> 2.34.1
> 

The rest looks good to me. Thanks!

Acked-by: Daniel Müller <deso@posteo.net>
