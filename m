Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 808F68B996
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 15:09:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728952AbfHMNJo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 09:09:44 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:35530 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728548AbfHMNJn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 09:09:43 -0400
Received: by mail-wm1-f66.google.com with SMTP id l2so1406303wmg.0
        for <netdev@vger.kernel.org>; Tue, 13 Aug 2019 06:09:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=fBSwKRQRFtjc++Itb2fNjwWiILszK6eORmY1dPCJdUQ=;
        b=lC9tcbieOI+w9hLY9uHAqSQWU9hy2j8Mr5I1AOSNVb71zGwZvEQH/irk6FPNvV+7Wl
         rj4SZWbLesWpdT52pzkVgmbMlGgycA5X9rUx3QBfdbze2sLc0qFxcWlxOiCsOD3NX1CP
         N+9IyJJh3dI3zFQoMbdCFr/XquVps8LAWPzlS2w5DzPK6atPHGv2AQEaco10z9YZVspx
         1+f74ZHvEykWc5dSlBU1qtQ5uZ7rHbUiIWKI57Hrnkjdl1u1GsJTZa/XFKyKwLcxk0f+
         8xWEHzm4DKB3Q/Ojgt+YDpoDbAvBSh1S2dT5rWmRHjwgNo3XleYfCUPZ/CLYBTDvKkFT
         hfew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=fBSwKRQRFtjc++Itb2fNjwWiILszK6eORmY1dPCJdUQ=;
        b=EyMz0J2JwVWsI+9j4F1li2r21NOuc/YO+HykDhGOCAjGMQ47rkvypSjTJY0KFbDu2J
         8Rr1v4xlcc24XO4zLZkC7R4642bnEuATkYfMQBxGxmJgzBNmym2DahA0rRUQqxOAM87r
         X3VhO7wjUvLEWxBGOZpKSMzB/gDv3vFcG55FoAshvGECFeOzZcVOfnd3QA2yN6/w95Km
         NOkwIIlUBakJcNeRXtraZih7Qr8+JDg/MNbi1hC0PqtTFBrpVnyABN2h3cv+GGyYRSmz
         HRlyOkzK1IFyMBA5euT5+dIr5tCq0xIdWRPa7585CpJHEJt5NnISVq6Yz7Mocf2mIdRF
         gqnQ==
X-Gm-Message-State: APjAAAVFlLHlRQBfRihenMDbPETYs/DbXhzRu2r/MNCOAA/YTce3rn50
        aqy/CxWPR75L6bxvuWsmMh6DNQ==
X-Google-Smtp-Source: APXvYqwfD4tzVtlkVpnEOpTAP+MB++U2UgrC+2KALOHSldAM+3AUh0DnCcNwO14L4gz2ww4FC9nqow==
X-Received: by 2002:a7b:c155:: with SMTP id z21mr3112053wmi.137.1565701779904;
        Tue, 13 Aug 2019 06:09:39 -0700 (PDT)
Received: from cbtest32.netronome.com ([217.38.71.146])
        by smtp.gmail.com with ESMTPSA id e3sm130534191wrs.37.2019.08.13.06.09.38
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 13 Aug 2019 06:09:38 -0700 (PDT)
From:   Quentin Monnet <quentin.monnet@netronome.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com,
        Quentin Monnet <quentin.monnet@netronome.com>
Subject: [RFC bpf-next 3/3] tools: bpftool: add "bpftool map count" to count entries in map
Date:   Tue, 13 Aug 2019 14:09:21 +0100
Message-Id: <20190813130921.10704-4-quentin.monnet@netronome.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190813130921.10704-1-quentin.monnet@netronome.com>
References: <20190813130921.10704-1-quentin.monnet@netronome.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a "map count" subcommand for counting the number of entries in a
map.

Because of the variety of BPF map types, it is not entirely clear what
counts as an "entry" to dump. We could count all entries for which we
have keys; but then for all array derivatives, it would simply come down
to printing the maximum number of entries (already accessible through
"bpftool map show").

Several map types set errno to ENOENT when they consider there is no
value associated to a key, so we could maybe use that... But then there
are also some map types that simply reject lookup attempts with
EONOTSUPP (xskmap, sock_map, sock_hash): Not being able to lookup a
value in such maps does not mean they have no values.

Instead of trying to enforce a definition for a "map entry", the
selected approach in this patch consists in dumping several counter, and
letting the user decide how to interpret them. Values printed are:

  - Max number of entries
  - Number of key found
  - Number of successful lookups
  - Number of failed lookups, broken down into the most frequent values
    for errno (ENOENT, EOPNOTSUPP, EINVAL, EPERM).

Not all possible values for errno are included (e.g. ENOMEM or EFAULT,
for example), they can be added in the future if necessary.

Below are some sample output with different types of maps.

Array map:

        # bpftool map count id 11
        max entries:            2
        keys found:             2
        successful lookups:     2

Empty prog_array map:

        # bpftool map count id 13
        max entries:            5
        keys found:             5
        successful lookups:     0
        failed lookups: 5, of which:
          - errno set to ENOENT:        5

Empty xskmap:

        # bpftool map count id 14
        max entries:            5
        keys found:             5
        successful lookups:     0
        failed lookups: 5, of which:
          - errno set to EOPNOTSUPP:    5

JSON for the array map:

        # bpftool map count id 11
        {
            "max_entries": 2,
            "n_keys": 2,
            "n_lookup_success": 2,
            "lookup_failures": {
                "enoent": 0,
                "eopnotsupp": 0,
                "einval": 0,
                "eperm": 0,
            }
        }

Queue map containing 3 items:

        # bpftool map count id 12
        failed to get next key, interrupting count: Invalid argument
        max entries:            5
        keys found:             0
        successful lookups:     0

Note that counting entries for queue and stack maps is not supported
(beyond max_entries), as these types do not support cycling over the
keys.

This commit also adds relevant documentation and bash completion.

Signed-off-by: Quentin Monnet <quentin.monnet@netronome.com>
Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
---
 .../bpf/bpftool/Documentation/bpftool-map.rst | 15 +++
 tools/bpf/bpftool/bash-completion/bpftool     |  4 +-
 tools/bpf/bpftool/map.c                       | 97 ++++++++++++++++++-
 3 files changed, 113 insertions(+), 3 deletions(-)

diff --git a/tools/bpf/bpftool/Documentation/bpftool-map.rst b/tools/bpf/bpftool/Documentation/bpftool-map.rst
index 61d1d270eb5e..ccc19bdd2ca3 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-map.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-map.rst
@@ -25,6 +25,7 @@ MAP COMMANDS
 |	**bpftool** **map create**     *FILE* **type** *TYPE* **key** *KEY_SIZE* **value** *VALUE_SIZE* \
 |		**entries** *MAX_ENTRIES* **name** *NAME* [**flags** *FLAGS*] [**dev** *NAME*]
 |	**bpftool** **map dump**       *MAP*
+|	**bpftool** **map count**      *MAP*
 |	**bpftool** **map update**     *MAP* [**key** *DATA*] [**value** *VALUE*] [*UPDATE_FLAGS*]
 |	**bpftool** **map lookup**     *MAP* [**key** *DATA*]
 |	**bpftool** **map getnext**    *MAP* [**key** *DATA*]
@@ -67,6 +68,20 @@ DESCRIPTION
 	**bpftool map dump**    *MAP*
 		  Dump all entries in a given *MAP*.
 
+	**bpftool map count**   *MAP*
+		  Count the number of entries in a given *MAP*. Several values
+		  are printed: the maximum number of entries, the number of
+		  keys found, the number of successful lookups with those keys.
+		  The report for failed lookups is broken down to give values
+		  for the most frequent **errno** values.
+
+		  Note that the counters may not be accurate if the map is
+		  being modified (for example by a running BPF program). For
+		  example, if an element gets removed while being dumped, and
+		  then passed in as the "previous key" while cycling over map
+		  keys, the dump will restart and bpftool will count the
+		  entries multiple times.
+
 	**bpftool map update**  *MAP* [**key** *DATA*] [**value** *VALUE*] [*UPDATE_FLAGS*]
 		  Update map entry for a given *KEY*.
 
diff --git a/tools/bpf/bpftool/bash-completion/bpftool b/tools/bpf/bpftool/bash-completion/bpftool
index df16c5415444..764c88bfe9da 100644
--- a/tools/bpf/bpftool/bash-completion/bpftool
+++ b/tools/bpf/bpftool/bash-completion/bpftool
@@ -449,7 +449,7 @@ _bpftool()
         map)
             local MAP_TYPE='id pinned'
             case $command in
-                show|list|dump|peek|pop|dequeue)
+                show|list|dump|count|peek|pop|dequeue)
                     case $prev in
                         $command)
                             COMPREPLY=( $( compgen -W "$MAP_TYPE" -- "$cur" ) )
@@ -642,7 +642,7 @@ _bpftool()
                     [[ $prev == $object ]] && \
                         COMPREPLY=( $( compgen -W 'delete dump getnext help \
                             lookup pin event_pipe show list update create \
-                            peek push enqueue pop dequeue' -- \
+                            peek push enqueue pop dequeue count' -- \
                             "$cur" ) )
                     ;;
             esac
diff --git a/tools/bpf/bpftool/map.c b/tools/bpf/bpftool/map.c
index cead639b3ab1..918d08d1676e 100644
--- a/tools/bpf/bpftool/map.c
+++ b/tools/bpf/bpftool/map.c
@@ -822,6 +822,98 @@ static int do_dump(int argc, char **argv)
 	return err;
 }
 
+static int do_count(int argc, char **argv)
+{
+	unsigned int num_keys = 0, num_lookups = 0;
+	unsigned int err_cnts[1024] = {};
+	struct bpf_map_info info = {};
+	void *key, *value, *prev_key;
+	__u32 len = sizeof(info);
+	int err, fd;
+
+	if (!REQ_ARGS(2))
+		return -1;
+
+	fd = map_parse_fd_and_info(&argc, &argv, &info, &len);
+	if (fd < 0)
+		return -1;
+
+	key = malloc(info.key_size);
+	value = alloc_value(&info);
+	if (!key || !value) {
+		p_err("mem alloc failed");
+		err = -1;
+		goto exit_free;
+	}
+
+	prev_key = NULL;
+	while (true) {
+		int res;
+
+		err = bpf_map_get_next_key(fd, prev_key, key);
+		if (err) {
+			if (errno == ENOENT)
+				err = 0;
+			else
+				p_info("failed to get next key, interrupting count: %s",
+				       strerror(errno));
+			break;
+		}
+
+		num_keys++;
+		res = bpf_map_lookup_elem(fd, key, value);
+		if (res) {
+			if (errno < (int)ARRAY_SIZE(err_cnts))
+				err_cnts[errno]++;
+		} else {
+			num_lookups++;
+		}
+		prev_key = key;
+	}
+
+	if (json_output) {
+		jsonw_start_object(json_wtr);	/* root */
+		jsonw_uint_field(json_wtr, "max_entries", info.max_entries);
+		jsonw_uint_field(json_wtr, "n_keys", num_keys);
+		jsonw_uint_field(json_wtr, "n_lookup_success", num_lookups);
+		jsonw_name(json_wtr, "lookup_failures");
+		jsonw_start_object(json_wtr);	/* lookup_failures */
+		jsonw_uint_field(json_wtr, "enoent", err_cnts[ENOENT]);
+		jsonw_uint_field(json_wtr, "eopnotsupp", err_cnts[EOPNOTSUPP]);
+		jsonw_uint_field(json_wtr, "einval", err_cnts[EINVAL]);
+		jsonw_uint_field(json_wtr, "eperm", err_cnts[EPERM]);
+		jsonw_end_object(json_wtr);	/* lookup_failures */
+		jsonw_end_object(json_wtr);	/* root */
+	} else {
+		printf("max entries:\t\t%u\n", info.max_entries);
+		printf("keys found:\t\t%u\n", num_keys);
+		printf("successful lookups:\t%u\n", num_lookups);
+		if (num_lookups != num_keys) {
+			printf("failed lookups:\t%u, of which:\n",
+			       num_keys - num_lookups);
+			if (err_cnts[ENOENT])
+				printf("  - errno set to ENOENT:\t%u\n",
+				       err_cnts[ENOENT]);
+			if (err_cnts[EOPNOTSUPP])
+				printf("  - errno set to EOPNOTSUPP:\t%u\n",
+				       err_cnts[EOPNOTSUPP]);
+			if (err_cnts[EINVAL])
+				printf("  - errno set to EINVAL:\t%u\n",
+				       err_cnts[EINVAL]);
+			if (err_cnts[EPERM])
+				printf("  - errno set to EPERM:\t\t%u\n",
+				       err_cnts[EPERM]);
+		}
+	}
+
+exit_free:
+	free(key);
+	free(value);
+	close(fd);
+
+	return err;
+}
+
 static int alloc_key_value(struct bpf_map_info *info, void **key, void **value)
 {
 	*key = NULL;
@@ -1250,6 +1342,7 @@ static int do_help(int argc, char **argv)
 		"                              entries MAX_ENTRIES name NAME [flags FLAGS] \\\n"
 		"                              [dev NAME]\n"
 		"       %s %s dump       MAP\n"
+		"       %s %s count      MAP\n"
 		"       %s %s update     MAP [key DATA] [value VALUE] [UPDATE_FLAGS]\n"
 		"       %s %s lookup     MAP [key DATA]\n"
 		"       %s %s getnext    MAP [key DATA]\n"
@@ -1279,7 +1372,8 @@ static int do_help(int argc, char **argv)
 		bin_name, argv[-2], bin_name, argv[-2], bin_name, argv[-2],
 		bin_name, argv[-2], bin_name, argv[-2], bin_name, argv[-2],
 		bin_name, argv[-2], bin_name, argv[-2], bin_name, argv[-2],
-		bin_name, argv[-2], bin_name, argv[-2], bin_name, argv[-2]);
+		bin_name, argv[-2], bin_name, argv[-2], bin_name, argv[-2],
+		bin_name, argv[-2]);
 
 	return 0;
 }
@@ -1301,6 +1395,7 @@ static const struct cmd cmds[] = {
 	{ "enqueue",	do_update },
 	{ "pop",	do_pop_dequeue },
 	{ "dequeue",	do_pop_dequeue },
+	{ "count",	do_count },
 	{ 0 }
 };
 
-- 
2.17.1

